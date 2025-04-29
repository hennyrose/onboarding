//
//  OnboardingService.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import Foundation

final class OnboardingService {

    func fetchOnboardingData(completion: @escaping (Result<[OnboardingModel], Error>) -> Void) {
        NetworkManager.shared.request(APIEndpoints.onboarding) { (result: Result<OnboardingResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    completion(.success(response.items))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
