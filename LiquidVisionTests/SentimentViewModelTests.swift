//
//  SentimentViewModelTests.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import XCTest
@testable import LiquidVision

@MainActor
final class MockSentimentAnalysisService: SentimentAnalysisServicing {
    var analyzeCallCount = 0
    var result: Result<SentimentAnalysisResult, Error>
    var receivedTexts: [String] = []

    init(result: Result<SentimentAnalysisResult, Error>) {
        self.result = result
    }

    func analyze(text: String) async throws -> SentimentAnalysisResult {
        analyzeCallCount += 1
        receivedTexts.append(text)
        return try result.get()
    }
}

@MainActor
final class SentimentViewModelTests: XCTestCase {
    func testAnalyzeSuccessUpdatesState() async throws {
        let mockResult = SentimentAnalysisResult(score: 0.75, sentiment: .positive)
        let service = MockSentimentAnalysisService(result: .success(mockResult))
        let viewModel = SentimentViewModel(service: service)
        viewModel.inputText = "Great experience!"

        viewModel.analyze()

        try await waitForCondition {
            service.analyzeCallCount == 1 && viewModel.isAnalyzing == false
        }

        XCTAssertEqual(viewModel.sentimentLabel, mockResult.sentiment.displayName)
        XCTAssertEqual(viewModel.sentimentScore, mockResult.score, accuracy: 0.001)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.hasResult)
        XCTAssertEqual(service.receivedTexts.last, "Great experience!")
    }

    func testAnalyzeSkipsWhenInputIsBlank() async throws {
        let service = MockSentimentAnalysisService(result: .success(SentimentAnalysisResult(score: 0.4, sentiment: .neutral)))
        let viewModel = SentimentViewModel(service: service)
        viewModel.inputText = ""

        viewModel.analyze()

        try await waitForCondition {
            viewModel.isAnalyzing == false
        }

        XCTAssertEqual(service.analyzeCallCount, 0)
        XCTAssertEqual(viewModel.errorMessage, SentimentAnalysisError.emptyText.errorDescription)
        XCTAssertFalse(viewModel.hasResult)
        XCTAssertEqual(viewModel.sentimentScore, 0)
        XCTAssertEqual(viewModel.sentimentLabel, "Enter text and tap Analyze")
    }

    func testAnalyzeTrimsWhitespaceBeforeSending() async throws {
        let mockResult = SentimentAnalysisResult(score: 0.2, sentiment: .negative)
        let service = MockSentimentAnalysisService(result: .success(mockResult))
        let viewModel = SentimentViewModel(service: service)
        viewModel.inputText = "   Needs improvement   "

        viewModel.analyze()

        try await waitForCondition {
            service.analyzeCallCount == 1 && viewModel.isAnalyzing == false
        }

        XCTAssertEqual(service.receivedTexts.last, "Needs improvement")
        XCTAssertEqual(viewModel.sentimentLabel, mockResult.sentiment.displayName)
    }
}
