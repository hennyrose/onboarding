//
//  OnboardingViewModel.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import Foundation

final class OnboardingViewModel {

    var onDataLoaded: (([OnboardingModel]) -> Void)?

    private let onboardingService = OnboardingService()

    func loadOnboardingData() {
        onboardingService.fetchOnboardingData { [weak self] result in
            switch result {
            case .success(let data):
                self?.onDataLoaded?(data)
            case .failure(let error):
                print("Error fetching onboarding data:", error)
            }
        }
    }
}
