//
//  PlantInfoView.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlantInfoView: View {
    @Binding var navigationPath: [MainNavigationPath]
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    @EnvironmentObject private var userState: UserState
    @EnvironmentObject private var localStorage: LocalStorage<RecentItem>
    @StateObject private var plantInfoModel: PlantInfoModel
    @State private var contentOffset: CGFloat = 0
    private let headerImageAspectRatio: CGFloat = 1.5
    
    private var identificationResponse: IdentificationResponse {
        return plantInfoModel.identificationResponse
    }
    
    private var navigationTitleOpacity: Double {
        let targetOpacity = contentOffset / navigationBarTitleFullOpacityThreshold
        return min(1, max(0, targetOpacity))
    }
    
    private var headerOffset: Double {
        return min(0, contentOffset / 2)
    }
    
    private var headerImageHeight: CGFloat {
        let imageWidth = UIScreen.main.bounds.width
        return imageWidth / headerImageAspectRatio
    }
    
    private var scrollingHeaderImageScaleFactor: CGFloat {
        let insetHeight = headerImageHeight - contentOffset
        let targetScale = insetHeight / headerImageHeight
        return max(1, targetScale)
    }
    
    private var navigationBarTitleFullOpacityThreshold: Double {
        return Double(headerImageHeight) / 2
    }
    
    // MARK: - Lifecycle
    init(identificationResponse: IdentificationResponse, navigationPath: Binding<[MainNavigationPath]>) {
        _plantInfoModel = StateObject(wrappedValue: PlantInfoModel(identificationResponse: identificationResponse))
        self._navigationPath = navigationPath
    }
    
    init(recentItem: RecentItem, navigationPath: Binding<[MainNavigationPath]>) {
        _plantInfoModel = StateObject(wrappedValue: PlantInfoModel(recentItem: recentItem))
        self._navigationPath = navigationPath
    }
    
    // MARK: - Views
    var body: some View {
        ZStack(alignment: .top) {
            ObservableScrollView(contentOffset: $contentOffset, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    header()
                    
                    PlantInfoSectionView(title: "COMMON NAME", systemImageName: "camera.macro") {
                        CopyableTextButton(text: identificationResponse.commonName)
                            .font(.system(.headline, design: .rounded))
                    }
                    
                    PlantInfoSectionView(title: "SCIENTIFIC NAME", systemImageName: "atom") {
                        CopyableTextButton(text: identificationResponse.scientificName)
                            .font(.system(.body, design: .serif, weight: .semibold))
                    }
                    
                    if let health = identificationResponse.health {
                        PlantInfoSectionView(title: "HEALTH STATUS", systemImageName: "heart.fill") {
                            PlantHealthBox(plantName: identificationResponse.commonName, health: health)
                        }
                    }
                    
                    infoBoxes()
                    
                    PlantInfoSectionView(title: "DESCRIPTION", systemImageName: "text.bubble") {
                        Text(identificationResponse.description)
                            .font(.system(.body, design: .rounded, weight: .regular))
                            .foregroundStyle(Color.title)
                            .lineSpacing(6)
                            .kerning(0.3)
                            .padding(.top, 4)
                    }
                    
                    imageCarousel()
                    
                    PlantInfoSectionView(title: "CARE INSTRUCTIONS", systemImageName: "text.badge.checkmark") {
                        CareInstructionsBox(mode: .instructions,
                                            plantName: identificationResponse.commonName,
                                            instructions: identificationResponse.careInstructions)
                    }
                    
                    if let bloomingSeason = identificationResponse.bloomingSeason {
                        PlantInfoSectionView(title: "BLOOMING SEASON", systemImageName: "star.fill") {
                            CopyableTextButton(text: bloomingSeason)
                        }
                    }
                    
                    if let uses = identificationResponse.uses {
                        PlantInfoSectionView(title: "USES", systemImageName: "info.circle.fill") {
                            CareInstructionsBox(mode: .uses, plantName: identificationResponse.commonName, instructions: uses)
                        }
                        .padding(.bottom)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            
            navigationBar()
        }
        .toolbar(.hidden, for: .navigationBar)
//        .requestsReview(isPresented: $requestReview)
        .task {
            guard plantInfoModel.didFetchRemoteImageData == false else {
                return
            }
            
            do {
                try await plantInfoModel.fetchImagesIfNeeded()
            } catch {
                print("Failed to fetch wiki images:\n\(error)")
            }
            
            saveRecentItem()
        }
        .task {
            // Request review
            try? await Task.sleep(for: .seconds(1))
            if userState.shouldRequestReview {
                requestReview()
            }
        }
    }
    
    private func navigationBar() -> some View {
        Text(identificationResponse.commonName)
            .font(.system(.title3, design: .rounded, weight: .semibold))
            .opacity(navigationTitleOpacity)
            .frame(maxWidth: .infinity)
            .overlay(content: navigationButtons)
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                Material.regularMaterial
                    .opacity(navigationTitleOpacity)
            )
    }
    
    @ViewBuilder private func header() -> some View {
        headerImage()
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(identificationResponse.commonName)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    
                    Text(identificationResponse.scientificName)
                        .font(.system(.headline, design: .rounded))
                }
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.35), radius: 5, y: 2)
                .kerning(1.0)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    LinearGradient(colors: [.black.opacity(0.5), .black.opacity(0)], startPoint: .bottom, endPoint: .top)
                }
            }
    }
    
    @ViewBuilder private func headerImage() -> some View {
        let headerImageData = plantInfoModel.imageData.first ?? .placeholder(aspectRatio: 1)
        let targetWidth = min(headerImageData.width, UIScreen.main.bounds.width * UIScreen.main.scale)
        let targetImageSize = CGSize(width: targetWidth, height: targetWidth / headerImageData.aspectRatio)
        
        WebImage(url: headerImageData.url, context: [.imageThumbnailPixelSize: targetImageSize])
            .resizable()
            .placeholder(content: defaultPlaceholder)
            .aspectRatio(contentMode: .fill)
            .scaledToFill(aspectRatio: headerImageAspectRatio)
            .overlay(alignment: .top) {
                LinearGradient(colors: [.black.opacity(0.6), .black.opacity(0)], startPoint: .top, endPoint: .bottom)
                    .frame(height: headerImageHeight / 2)
            }
            .scaleEffect(scrollingHeaderImageScaleFactor)
            .offset(y: headerOffset)
    }
    
    @ViewBuilder private func imageCarousel() -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(plantInfoModel.imageData, id: \.self, content: imageCarouselView)
            }
            .frame(height: 208)
            .modify { view in
                if #available(iOS 17, *) {
                    view.scrollTargetLayout()
                } else {
                    view
                }
            }
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .modify { view in
            if #available(iOS 17, *) {
                view.scrollTargetBehavior(.viewAligned)
            } else {
                view
            }
        }
    }
    
    @ViewBuilder private func imageCarouselView(for imageData: RemoteImageData) -> some View {
        let targetWidth = min(imageData.width, (UIScreen.main.bounds.width * 0.9) * UIScreen.main.scale)
        let targetImageSize = CGSize(width: targetWidth, height: targetWidth / imageData.aspectRatio)
        
        WebImage(url: imageData.url, context: [.imageThumbnailPixelSize: targetImageSize])
            .resizable()
            .placeholder(content: defaultPlaceholder)
            .aspectRatio(contentMode: .fill)
            .scaledToFill(aspectRatio: 1.5)
            .cornerRadius(style: .small, strokeColor: Color.separator, strokeWidth: 1)
        }
    
    private func defaultPlaceholder() -> some View {
        Rectangle()
            .fill(Color(.systemGray5))
    }
    
    private func infoBoxes() -> some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 8),
                            GridItem(.flexible(), spacing: 8)]) {
            PlantInfoBox(title: "TEMPERATURE", systemImageName: "thermometer.sun.fill", text: identificationResponse.temperatureRange)
            PlantInfoBox(title: "GEOGRAPHY", systemImageName: "globe.europe.africa.fill", text: identificationResponse.geography)
            PlantInfoBox(title: "SUNLIGHT", systemImageName: "sun.max", text: identificationResponse.sunlight)
            PlantInfoBox(title: "RARITY INDEX", systemImageName: "sparkles", text: identificationResponse.rarityIndex)
        }
        .padding(.horizontal)
    }
    
    private func navigationButtons() -> some View {
        HStack {
            UIFactory.createBackButton(action: dismiss.callAsFunction)
            Spacer()
            
            if FeatureFlags.isAIChatAvailable {
                chatButton()
            }
        }
        .foregroundStyle(contentOffset < navigationBarTitleFullOpacityThreshold ? .white : Color.title)
        .shadow(color: .black.opacity(0.5), radius: contentOffset < navigationBarTitleFullOpacityThreshold ? 12 : 0)
    }
    
    private func chatButton() -> some View {
        Button {
            AnalyticsService.logEvent(name: "plant_info_chat_tapped")
            navigationPath.append(.chat(identificationResponse))
        } label: {
            Image(systemName: "sparkles")
                .font(.system(size: 22, weight: .semibold))
        }
        .springButtonStyle()
        .modify { view in
            if #available(iOS 17, *) {
                view.popoverTip(ChatTip())
            } else {
                view
            }
        }
    }
    
    // MARK: - Private
    private func saveRecentItem() {
        let recentItem = RecentItem(identificationResponse: identificationResponse, imageData: plantInfoModel.imageData)
        localStorage.save(recentItem)
    }
}
