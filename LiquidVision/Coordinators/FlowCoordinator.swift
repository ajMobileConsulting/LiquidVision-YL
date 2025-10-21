//
//  FlowCoordinator.swift
//  LiquidVision
//
//  Created by Yassine Lamtalaa on 10/21/25.
//
import SwiftUI

protocol FlowCoordinator: AnyObject {
    @MainActor
    func start() -> AnyView
}
