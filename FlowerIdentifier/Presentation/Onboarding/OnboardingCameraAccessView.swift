//
//  OnboardingCameraPermissionView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 09/12/2023.
//

import SwiftUI

struct OnboardingCameraAccessView: View {
    let onFinish: () -> Void
    @StateObject private var cameraModel = CameraModel()
    
    var body: some View {
        VStack(spacing: 34) {
            Spacer()
            
            LottieView(fileName: "camera-permissions", loopMode: .loop, contentMode: .scaleAspectFit)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .scaleEffect(0.15)
                .opacity(0.25)
            
            enableCameraAccessView()
                .frame(maxWidth: .infinity)
            
            Spacer()
            
            PrimaryCTAButton(action: onFinish)
                .disabled(!cameraModel.isCameraAuthorized)
                .frame(height: 80, alignment: .top)
                .frame(maxWidth: 500)
        }
        .multilineTextAlignment(.center)
        .onChange(of: cameraModel.isCameraAuthorized) { isCameraAuthorized in
            if isCameraAuthorized {
                AnalyticsService.logEvent(name: "onboarding_camera_authorized")
            }
        }
        .onReceive(cameraModel.$cameraAuthorizationStatus) { status in
            switch status {
            case .denied, .restricted:
                AnalyticsService.logEvent(name: "onboarding_camera_denied")
                onFinish()
            default:
                break
            }
        }
    }
    
    private func enableCameraAccessView() -> some View {
        VStack(spacing: 16) {
            Text("Enable camera access to\nsnap photos directly from the app")
                .font(.system(.headline, design: .rounded, weight: .medium))
            
            Button {
                if cameraModel.cameraAuthorizationStatus == .notDetermined {
                    cameraModel.requestCameraAuthorization()
                } else {
                    Utilities.openAppSettings()
                }
            } label: {
                Text("\(cameraModel.isCameraAuthorized ? "✅" : "📷")  Enable Camera Access")
            }
            .disabled(cameraModel.isCameraAuthorized)
            .ctaButtonStyle(.secondary, size: .custom(height: 46))
        }
    }
}
