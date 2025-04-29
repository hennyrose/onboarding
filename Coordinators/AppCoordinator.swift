//
//  AppCoordinator.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var onboardingCoordinator: OnboardingCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        self.onboardingCoordinator = onboardingCoordinator
        onboardingCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
