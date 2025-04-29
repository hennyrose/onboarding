//
//  OnboardingCoordinator.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit

final class OnboardingCoordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let onboardingVC = OnboardingViewController()

        onboardingVC.onOnboardingFinished = { [weak self] in
            self?.showSaleScreen()
        }

        navigationController.setViewControllers([onboardingVC], animated: false)
    }

    private func showSaleScreen() {
        let saleVC = SaleScreenViewController()
        
        saleVC.onCloseSaleScreen = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        
        navigationController.present(saleVC, animated: true)
    }
}
