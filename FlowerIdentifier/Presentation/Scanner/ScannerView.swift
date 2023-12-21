//
//  ContentView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 27/11/2023.
//

import SwiftUI
import PhotosUI
import EKAppFramework

struct ScannerView: View {
    @EnvironmentObject private var appModel: AppModel
    @EnvironmentObject private var userState: UserState
    @StateObject private var scannerModel = ScannerModel()
    @StateObject private var cameraModel = CameraModel()
    @StateObject private var photoPickerModel = PhotoPickerModel()
    @StateObject private var identificationModel = IdentificationModel()
    @State private var shouldActivateCamera = true
    @State private var showsIdentificationErrorAlert = false
    @State private var showsLanguagePicker = false
    @State private var navigationPath = [MainNavigationPath]()
    
    private var isReadyForIdentification: Bool {
        if case .readyForIdentification = scannerModel.currentImage {
            return true
        }
        
        return false
    }
    
    // MARK: - Views
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Spacer()
                if let currentImage = scannerModel.currentImage {
                    PreviewView(image: currentImage.thumbnailImage, aspectRatio: currentImage.aspectRatio)
                        .overlay(alignment: .bottom, content: shutterView)
                        .overlay {
                            if identificationModel.isIdentiying {
                                LottieView(fileName: "scan-animation", loopMode: .repeat(.greatestFiniteMagnitude), speed: 0.9)
                            }
                        }
                        .overlay(content: viewfinderView)
                        .cornerRadius(style: .regular)
                        .shadow(color: .active.opacity(0.3), radius: 40)
                    
                    identificationUtilitiesIfNeeded()
                } else if cameraModel.isCameraAuthorized == false {
                    cameraUnauthorizedView()
                }
                
                Spacer()
                if isReadyForIdentification == false {
                    photoPickerSeparatorView()
                    PhotosPicker(selection: $photoPickerModel.photosPickerItem, label: photoPickerLabel)
                        .springButtonStyle()
                }
            }
            .frame(maxWidth: .infinity)
            .animation(.bouncy(duration: 0.3), value: identificationModel.isIdentiying)
            .animation(.bouncy(duration: 0.3), value: scannerModel.currentImage)
            .padding([.bottom, .horizontal], 24)
            .navigationTitle("Scanner")
            .mainNavigationDestination(navigationPath: $navigationPath)
            .toolbar {
                #if DEBUG
                ToolbarItem(placement: .topBarTrailing, content: debugButton)
                #endif
                
                ToolbarItem(placement: .topBarLeading, content: languageButton)
                ToolbarItem(placement: .topBarTrailing) {
                    CreditsButton {
                        if userState.isSubscribed == false {
                            appModel.showsSubscription = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing, content: settingsButton)
            }
            .background(Color.background)
        }
        .errorAlert(title: "Something Went Wrong 😕",
                    message: "There was a problem identifying this plant. Please try again or choose a different photo.",
                    isPresented: $showsIdentificationErrorAlert)
        .sheet(isPresented: $showsLanguagePicker) {
            LanguagePicker(selection: userState.$preferredLanguage)
        }
        .task(id: shouldActivateCamera) {
            if shouldActivateCamera {
                cameraModel.startCamera()
            } else {
                cameraModel.stopCamera()
            }
        }
        .onAppear {
            shouldActivateCamera = true
        }
        .onChange(of: navigationPath) { navigationPath in
            if navigationPath.isEmpty {
                shouldActivateCamera = true
            }
        }
        .onReceive(cameraModel.$previewImage) { image in
            if let image {
                scannerModel.currentImage = .cameraPreview(image)
            }
        }
        .onReceive(cameraModel.$outputPhotoData) { photoData in
            if let photoData {
                scannerModel.currentImage = .readyForIdentification(photoData)
            }
        }
        .onReceive(photoPickerModel.$photoState) { photoState in
            switch photoState {
            case .loaded(let image):
                if let photoData = image.createPhotoData() {
                    scannerModel.currentImage = .readyForIdentification(photoData)
                }
            default:
                break
            }
        }
        .onReceive(scannerModel.$currentImage) { currentImage in
            if case .readyForIdentification = currentImage {
                cameraModel.isPreviewPaused = true
            } else if cameraModel.isPreviewPaused {
                cameraModel.isPreviewPaused = false
            }
        }
        .onReceive(identificationModel.$isIdentiying) { isIdentifying in
            if navigationPath.isEmpty {
                shouldActivateCamera = !isIdentifying
            }
        }
        .onReceive(identificationModel.$result) { identificationResult in
            switch identificationResult {
            case .success(let result):
                AnalyticsService.logEvent(name: "identification_completed", params: [
                    "totalTime": result.metrics.totalTime,
                    "modelDetail": result.metrics.detail.rawValue,
                ])
                
                userState.numberOfIdentifications += 1
                navigationPath.append(.plantInfoView(result.response))
            case .failure:
                showsIdentificationErrorAlert = true
            case nil:
                break
            }
        }
    }
    
    @ViewBuilder private func shutterView() -> some View {
        if !cameraModel.isPreviewPaused {
            LinearGradient(colors: [.black.opacity(0.4), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                .frame(height: 80)
                .overlay(content: shutterButton)
                .overlay(alignment: .bottomTrailing, content: flashButton)
        }
    }
    
    private func shutterButton() -> some View {
        ShutterButton {
            AnalyticsService.logEvent(name: "scanner_shutter_tapped")
            cameraModel.takePhoto()
        }
        .padding(.bottom, 16)
    }
    
    private func flashButton() -> some View {
        Button {
            AnalyticsService.logEvent(name: "scanner_toggle_flash")
            cameraModel.isFlashEnabled.toggle()
        } label: {
            Image(systemName: cameraModel.isFlashEnabled ? "bolt" : "bolt.slash")
                .font(.system(.body, weight: .semibold))
                .foregroundStyle(.white)
                .padding(8)
                .background(Color.active.opacity(cameraModel.isFlashEnabled ? 0.5 : 0.2))
                .animation(.linear(duration: 0.2), value: cameraModel.isFlashEnabled)
                .clipShape(Circle())
        }
        .springButtonStyle()
        .padding([.bottom, .trailing], 16)
    }
    
    @ViewBuilder private func viewfinderView() -> some View {
        if !cameraModel.isPreviewPaused {
            ViewfinderView(insets: .init(top: 40, left: 40, bottom: 100, right: 40))
        }
    }
    
    @ViewBuilder private func identificationUtilitiesIfNeeded() -> some View {
        if identificationModel.isIdentiying {
            identifyingUtilityView()
        } else {
            readyForIdentificationUtilityView()
        }
    }
    
    private func photoPickerLabel() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "photo.on.rectangle.angled")
            Text("Pick a photo from library")
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.system(.headline, design: .rounded, weight: .medium))
        .padding(16)
        .cornerRadius(style: .small, strokeColor: .primary.opacity(0.1), strokeWidth: 1)
    }
    
    private func photoPickerSeparatorView() -> some View {
        HStack(spacing: 12) {
            separator()
            Text("OR")
                .foregroundStyle(Color.subtitle)
                .font(.system(.footnote, design: .rounded, weight: .medium))
            separator()
        }
    }
    
    private func identifyingUtilityView() -> some View {
        VStack(spacing: 20) {
            DetectionLoadingView()
            
            Button {
                AnalyticsService.logEvent(name: "scanner_cancel")
                identificationModel.cancelCurrentIdentification()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "stop.fill")
                    Text("Stop")
                }
                .frame(width: 90)
            }
            .ctaButtonStyle(.secondary)
        }
    }
    
    @ViewBuilder private func readyForIdentificationUtilityView() -> some View {
        if case .readyForIdentification(let photoData) = scannerModel.currentImage {
            HStack(spacing: 16) {
                Button(action: reset) {
                    Text("Start Over")
                        .frame(width: 90)
                }
                .ctaButtonStyle(.secondary)
                
                Button {
                    if identificationModel.isIdentiying {
                        identificationModel.cancelCurrentIdentification()
                    } else {
                        if userState.isEligibleForOutput {
                            AnalyticsService.logEvent(name: "scanner_identify_start")
                            identificationModel.identify(photoData: photoData,
                                                         language: userState.preferredLanguage?.name ?? "English")
                        } else {
                            AnalyticsService.logEvent(name: "scanner_identify_paywall")
                            appModel.showsSubscription = true
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "viewfinder")
                        Text("Scan")
                    }
                    .frame(width: 90)
                }
                .ctaButtonStyle(.primary)
            }
        }
    }
    
    private func separator() -> some View {
        Rectangle()
            .fill(Color.separator)
            .frame(height: 1)
    }
    
    private func cameraUnauthorizedView() -> some View {
        VStack(spacing: 32) {
            VStack(spacing: 8) {
                Text("No Camera Permissions 😕")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.title)
                
                Text("Enable camera access to snap photos directly from the app")
                    .font(.system(.callout, design: .rounded, weight: .medium))
                    .foregroundStyle(Color.subtitle)
            }
            .multilineTextAlignment(.center)
            
            Button(action: Utilities.openAppSettings) { 
                Text("Enable Camera Access")
            }
            .ctaButtonStyle(.secondary, size: .custom(height: 42))
        }
    }
    
    private func debugButton() -> some View {
        Button {
            appModel.showsDebugMenu = true
        } label: {
            Image(systemName: "ladybug.fill")
        }
        .navigationButtonStyle()
    }
    
    private func settingsButton() -> some View {
        Button {
            appModel.showsSettings = true
        } label: {
            Image(systemName: "gearshape.fill")
        }
        .navigationButtonStyle()
    }
    
    private func languageButton() -> some View {
        Button {
            showsLanguagePicker = true
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "globe")
                Text(userState.preferredLanguage?.name ?? "English")
                    .font(.system(.callout, design: .rounded, weight: .medium))
            }
        }
        .navigationButtonStyle()
    }
    
    // MARK: - Private
    private func reset() {
        AnalyticsService.logEvent(name: "scanner_start_over_tapped")
        scannerModel.currentImage = nil
        cameraModel.outputPhotoData = nil
    }
}
