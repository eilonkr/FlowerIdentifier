//
//  Camera.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 27/11/2023.
//

import AVFoundation
import UIKit
import os.log

class CameraService: NSObject {
    var didCapturePhoto: ((AVCapturePhoto) -> Void)?
    var isFlashEnabled = false
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                continuation.yield(ciImage)
            }
        }
    }()
    
    var isRunning: Bool {
        return captureSession.isRunning
    }

    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue = DispatchQueue(label: "sessionQueue")
    private var addToPreviewStream: ((CIImage) -> Void)?
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice else {
                return
            }
            
            logger.debug("Using capture device: \(captureDevice.localizedName)")
            sessionQueue.async { [weak self] in
                self?.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }
    
    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == UIDeviceOrientation.unknown {
            orientation = UIScreen.main.orientation
        }
        
        return orientation
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        initialize()
    }

    // MARK: - Public
    func checkAuthorization() -> AVAuthorizationStatus {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authorizationStatus {
        case .authorized:
            logger.debug("Camera access authorized.")
        case .notDetermined:
            logger.debug("Camera access not determined.")
            //sessionQueue.suspend()
            //sessionQueue.resume()
        case .denied:
            logger.debug("Camera access denied.")
        case .restricted:
            logger.debug("Camera library access restricted.")
        @unknown default:
            break
        }
        
        return authorizationStatus
    }
    
    func requestCameraAuthorization() async -> AVAuthorizationStatus {
        await AVCaptureDevice.requestAccess(for: .video)
        
        return checkAuthorization()
    }
    
    func start() {
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async { [weak self] in
                    self?.captureSession.startRunning()
                }
            }
            return
        }
        
        sessionQueue.async { [self] in
            self.configureCaptureSession { success in
                guard success else {
                    return
                }
                
                self.captureSession.startRunning()
            }
        }
    }
    
    func stop() {
        guard isCaptureSessionConfigured else {
            return
        }
        
        if captureSession.isRunning {
            sessionQueue.async { [weak self] in
                self?.captureSession.stopRunning()
            }
        }
    }
    
    func takePhoto() {
        guard let photoOutput else {
            return
        }
        
        sessionQueue.async {
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            
            let isFlashAvailable = self.deviceInput?.device.isFlashAvailable == true
            photoSettings.flashMode = isFlashAvailable ? (self.isFlashEnabled ? .on : .off) : .off
            photoSettings.isHighResolutionPhotoEnabled = true
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            
            photoSettings.photoQualityPrioritization = .balanced
            
            if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
                if photoOutputVideoConnection.isVideoOrientationSupported,
                   let videoOrientation = self.deviceOrientation.avCaptureVideoOrientation {
                    photoOutputVideoConnection.videoOrientation = videoOrientation
                }
            }
            
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    @objc func updateForDeviceOrientation() {
        //TODO: Figure out if we need this for anything.
    }
    
    // MARK: - Private
    private func initialize() {
        captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(updateForDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        var success = false
        
        captureSession.beginConfiguration()
        
        defer {
            captureSession.commitConfiguration()
            completionHandler(success)
        }
        
        guard let captureDevice = captureDevice,
              let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            logger.error("Failed to obtain video input.")
            return
        }
        
        let photoOutput = AVCapturePhotoOutput()
                        
        captureSession.sessionPreset = .photo

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDataOutputQueue"))
  
        guard captureSession.canAddInput(deviceInput) else {
            logger.error("Unable to add device input to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(photoOutput) else {
            logger.error("Unable to add photo output to capture session.")
            return
        }
        
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(photoOutput)
        captureSession.addOutput(videoOutput)
        
        self.deviceInput = deviceInput
        self.photoOutput = photoOutput
        self.videoOutput = videoOutput
        
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.maxPhotoQualityPrioritization = .quality
                
        isCaptureSessionConfigured = true
        
        success = true
    }
    
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let device else {
            return nil
        }
        
        do {
            return try AVCaptureDeviceInput(device: device)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else {
            return
        }
        
        captureSession.beginConfiguration()

        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }
        
        if let deviceInput = deviceInputFor(device: captureDevice) {
            if !captureSession.inputs.contains(deviceInput), captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        }
        
        captureSession.commitConfiguration()
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error {
            logger.error("Error capturing photo: \(error.localizedDescription)")
            return
        }
        
        didCapturePhoto?(photo)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraService: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        
        if connection.isVideoOrientationSupported,
           let videoOrientation = deviceOrientation.avCaptureVideoOrientation {
            connection.videoOrientation = videoOrientation
        }

        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
    }
}

fileprivate let logger = Logger(subsystem: "com.eilon.plantai", category: "Camera")

