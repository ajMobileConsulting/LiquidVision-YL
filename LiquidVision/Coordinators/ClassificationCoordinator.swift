//
//  ClassificationCoordinator.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import SwiftUI
import UIKit

@MainActor
final class ClassificationCoordinator: FlowCoordinator {
    private let classifier: ImageClassificationServicing
    private let sentimentService: SentimentAnalysisServicing

    init(classifier: ImageClassificationServicing = MobileNetImageClassifier(),
         sentimentService: SentimentAnalysisServicing = SentimentAnalysisService()) {
        self.classifier = classifier
        self.sentimentService = sentimentService
    }

    func start() -> AnyView {
        let viewModel = ClassificationViewModel(
            classifier: classifier,
            sentimentService: sentimentService
        )
        return AnyView(ClassificationScene(viewModel: viewModel, coordinator: self))
    }

    @ViewBuilder
    private func cameraView(for viewModel: ClassificationViewModel) -> some View {
        CameraView(
            selectedImage: Binding(
                get: { viewModel.selectedImage },
                set: { viewModel.selectedImage = $0 }
            ),
            onCapture: { image in
                viewModel.handleCapturedImage(image)
            }
        )
    }

    private struct ClassificationScene: View {
        @StateObject private var viewModel: ClassificationViewModel
        @State private var isCameraPresented = false

        let coordinator: ClassificationCoordinator

        init(viewModel: ClassificationViewModel, coordinator: ClassificationCoordinator) {
            _viewModel = StateObject(wrappedValue: viewModel)
            self.coordinator = coordinator
        }

        var body: some View {
            ClassificationView(
                viewModel: viewModel,
                isCameraPresented: $isCameraPresented,
                onCameraTap: { isCameraPresented = true }
            )
            .sheet(isPresented: $isCameraPresented) {
                coordinator.cameraView(for: viewModel)
            }
        }
    }
}
