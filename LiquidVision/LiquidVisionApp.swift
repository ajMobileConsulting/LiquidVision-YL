//
//  LiquidVisionApp.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import SwiftUI

@main
struct LiquidVisionApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
