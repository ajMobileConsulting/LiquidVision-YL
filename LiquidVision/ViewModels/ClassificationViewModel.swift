//
//  ClassificationViewModel.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import Foundation
import PhotosUI
import SwiftUI
import UIKit

@MainActor
final class ClassificationViewModel: ObservableObject {
    // TODO: Refactor View Models should not hold UI views we may use business logic to munipulate but not hold its value.
    @Published var selectedImage: UIImage?
    @Published var prediction: String = "Tap below to get started"
    @Published var confidence: Double = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var predictionSentimentLabel: String = ""
    @Published var predictionSentimentScore: Double = 0
    @Published var isAnalyzingSentiment = false
    @Published var predictionSentimentErrorMessage: String?

    private let classifier: ImageClassificationServicing
    private let sentimentService: SentimentAnalysisServicing

    init(classifier: ImageClassificationServicing = MobileNetImageClassifier(),
         sentimentService: SentimentAnalysisServicing = SentimentAnalysisService()) {
        self.classifier = classifier
        self.sentimentService = sentimentService
    }

    func processPickedItem(_ item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                errorMessage = "Unable to load image."
                return
            }
            selectedImage = uiImage
            classify(image: uiImage)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func handleCapturedImage(_ image: UIImage) {
        selectedImage = image
        classify(image: image)
    }

    private func classify(image: UIImage) {
        isLoading = true
        errorMessage = nil
        resetSentimentState()

        Task {
            do {
                let result = try await classifier.classify(image: image)
                prediction = result.identifier.capitalized
                confidence = result.confidence
                isLoading = false

                await analyzePredictionSentiment(for: prediction)
            } catch {
                isLoading = false
                isAnalyzingSentiment = false
                if let classificationError = error as? ImageClassificationError {
                    errorMessage = classificationError.errorDescription
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func resetSentimentState() {
        predictionSentimentLabel = ""
        predictionSentimentScore = 0
        predictionSentimentErrorMessage = nil
        isAnalyzingSentiment = true
    }

    private func analyzePredictionSentiment(for text: String) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else {
            predictionSentimentErrorMessage = SentimentAnalysisError.emptyText.errorDescription
            isAnalyzingSentiment = false
            return
        }

        do {
            let sentimentResult = try await sentimentService.analyze(text: trimmed)
            predictionSentimentLabel = sentimentResult.sentiment.displayName
            predictionSentimentScore = sentimentResult.score
            predictionSentimentErrorMessage = nil
        } catch let error as SentimentAnalysisError {
            predictionSentimentErrorMessage = error.errorDescription
            predictionSentimentLabel = ""
            predictionSentimentScore = 0
        } catch {
            predictionSentimentErrorMessage = error.localizedDescription
            predictionSentimentLabel = ""
            predictionSentimentScore = 0
        }

        isAnalyzingSentiment = false
    }
}
