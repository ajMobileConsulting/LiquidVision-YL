//
//  SentimentViewModel.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import Foundation
import SwiftUI

@MainActor
final class SentimentViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var sentimentLabel: String
    @Published var sentimentScore: Double = 0
    @Published var isAnalyzing = false
    @Published var errorMessage: String?

    private let service: SentimentAnalysisServicing
    private let defaultLabel = "Enter text and tap Analyze"
    private let analyzingLabel = "Analyzing..."

    init(service: SentimentAnalysisServicing = SentimentAnalysisService()) {
        self.service = service
        sentimentLabel = defaultLabel
    }

    var hasResult: Bool {
        ![defaultLabel, analyzingLabel].contains(sentimentLabel)
    }

    func analyze() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard trimmed.isEmpty == false else {
            isAnalyzing = false
            errorMessage = SentimentAnalysisError.emptyText.errorDescription
            sentimentLabel = defaultLabel
            sentimentScore = 0
            return
        }

        isAnalyzing = true
        errorMessage = nil
        sentimentLabel = analyzingLabel

        Task {
            do {
                let result = try await service.analyze(text: trimmed)
                sentimentScore = result.score
                sentimentLabel = result.sentiment.displayName
                isAnalyzing = false
            } catch let error as SentimentAnalysisError {
                isAnalyzing = false
                errorMessage = error.errorDescription
                sentimentLabel = defaultLabel
                sentimentScore = 0
            } catch {
                isAnalyzing = false
                errorMessage = error.localizedDescription
                sentimentLabel = defaultLabel
                sentimentScore = 0
            }
        }
    }
}
