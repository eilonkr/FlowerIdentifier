//
//  IdentificationModel.swift
//  PlantIdentifierAI
//
//  Created by Eilon Krauthammer on 28/11/2023.
//

import UIKit
import ChatGPTSwift

@MainActor class IdentificationModel: ObservableObject {
    struct IdentificationMetrics {
        let totalTime: TimeInterval
        let detail: ImageInput.Detail
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
                let detail: ImageInput.Detail = FeatureFlags.isHighDetailImageInput ? .high : .low
                let imageInput = ImageInput(imageType: .base64Encoded(imageData.base64EncodedString(), .jpeg),
                                            detail: detail)
                let response = try await gptService.sendIdentificationMessage(input: imageInput,
                                                                              model: .model4Turbo,
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
