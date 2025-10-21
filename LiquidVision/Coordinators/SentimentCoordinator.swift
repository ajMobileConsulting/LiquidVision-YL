//
//  SentimentCoordinator.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import SwiftUI

@MainActor
final class SentimentCoordinator: FlowCoordinator {
    private let service: SentimentAnalysisServicing

    init(service: SentimentAnalysisServicing = SentimentAnalysisService()) {
        self.service = service
    }

    func start() -> AnyView {
        let viewModel = SentimentViewModel(service: service)
        return AnyView(SentimentView(viewModel: viewModel))
    }
}
