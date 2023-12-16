//
//  CameraModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI
import AVFoundation

@MainActor class CameraModel: ObservableObject {
    var isPreviewPaused = false
    private let cameraService = CameraService()
    private var previewTask: Task<Void, Never>?
    
    @Published var previewImage: Image?
    @Published var cameraAuthorizationStatus: AVAuthorizationStatus?
    @Published var outputPhotoData: PhotoData?
    @Published var isFlashEnabled = false {
        didSet {
            cameraService.isFlashEnabled = isFlashEnabled
        }
    }
    
    var isCameraAuthorized: Bool {
        return cameraAuthorizationStatus == .authorized
    }
    
    // MARK: - Lifecycle
    init() {
        cameraService.isFlashEnabled = isFlashEnabled
        cameraService.didCapturePhoto = { [weak self] photo in
            self?.didCapturePhoto(photo)
        }
        
        cameraAuthorizationStatus = determineCameraAuthorization()
    }
    
    // MARK: - Public
    func startCamera() {
        guard isCameraAuthorized else {
            return
        }
        
        if cameraService.isRunning == false {
            cameraService.start()
            previewTask = startPreview()
        }
    }
    
    func stopCamera() {
        cameraService.stop()
    }
    
    func takePhoto() {
        cameraService.takePhoto()
    }
    
    func requestCameraAuthorization() {
        Task {
            cameraAuthorizationStatus = await cameraService.requestCameraAuthorization()
        }
    }
    
    // MARK: - Private
    private func determineCameraAuthorization() -> AVAuthorizationStatus {
        return cameraService.checkAuthorization()
    }
    
    private func startPreview() -> Task<Void, Never> {
        Task {
            let previewStream = cameraService.previewStream.map(\.image)
            for await image in previewStream {
                if !isPreviewPaused {
                    previewImage = image
                }
            }
        }
    }
    
    private func didCapturePhoto(_ photo: AVCapturePhoto) {
        let photoData = photo.createPhotoData()
        outputPhotoData = photoData
    }
}
