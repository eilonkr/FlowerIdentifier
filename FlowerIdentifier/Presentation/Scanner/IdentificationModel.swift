//
//  IdentificationModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import UIKit
import ChatGPTSwift

typealias ImageDetail = Components.Schemas.ChatCompletionRequestMessageContentPartImage.image_urlPayload.detailPayload

@MainActor class IdentificationModel: ObservableObject {
    struct IdentificationMetrics {
        let totalTime: TimeInterval
        let detail: ImageDetail
    }
    
    struct IdentificationResult {
        let response: IdentificationResponse
        let metrics: IdentificationMetrics
    }
    
    private lazy var gptService = GPTServiceResolver.resolveCurrentService()
    private var identificationTask: Task<Void, Never>? {
        didSet {
            isIdentiying = identificationTask != nil
        }
    }
    
    @Published var isIdentiying = false
    @Published var result: Result<IdentificationResult, Error>?
    
    // MARK: - Public
    func identify(photoData: PhotoData, language: String) {
        identificationTask = Task {
            let startTime = CACurrentMediaTime()
            
            defer {
                isIdentiying = false
            }
            
            let imageData = await photoData.downsampledJPEGImageData(maxSize: CGSize(width: 1920, height: 1920))
            do {
                let detail: ImageDetail = FeatureFlags.isHighDetailImageInput ? .high : .low
                let imageInput = ImageInput(data: imageData, detail: detail)
                let response = try await gptService.sendIdentificationMessage(imageInput: imageInput,
                                                                              model: .model4O,
                                                                              language: language,
                                                                              temperature: 0.5)
                
                let endTime = CACurrentMediaTime()
                let metrics = IdentificationMetrics(totalTime: endTime - startTime, detail: detail)
                
                result = .success(IdentificationResult(response: response, metrics: metrics))
            } catch {
                print("Identification error:\n\(error)")
                let isTaskCancellation = error is CancellationError
                let isAPICancellationError = (error as NSError).code == -999
                
                if isTaskCancellation == false && isAPICancellationError == false {
                    result = .failure(error)
                }
            }
        }
    }
    
    func cancelCurrentIdentification() {
        identificationTask?.cancel()
        identificationTask = nil
    }
    
    // MARK: - Private
}
