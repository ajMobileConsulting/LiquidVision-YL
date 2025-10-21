//
//  AppCoordinator.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject, FlowCoordinator {
    private let classificationCoordinator: ClassificationCoordinator
    private let sentimentCoordinator: SentimentCoordinator

    init(
        classificationCoordinator: ClassificationCoordinator? = nil,
        sentimentCoordinator: SentimentCoordinator? = nil
    ) {
        self.classificationCoordinator = classificationCoordinator ?? ClassificationCoordinator()
        self.sentimentCoordinator = sentimentCoordinator ?? SentimentCoordinator()
    }

    func start() -> AnyView {
        let classificationView = classificationCoordinator.start()
        let sentimentView = sentimentCoordinator.start()

        return AnyView(
            TabView {
                classificationView
                    .tabItem { Label("Vision", systemImage: "photo") }
                    .tag(0)

                sentimentView
                    .tabItem { Label("Sentiment", systemImage: "text.quote") }
                    .tag(1)
            }
        )
    }
}
