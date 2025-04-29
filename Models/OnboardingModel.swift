//
//  OnboardingModel.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import Foundation

struct OnboardingResponse: Decodable {
    let items: [OnboardingModel]
}

struct OnboardingModel: Decodable {
    let id: Int
    let question: String
    let answers: [String]
    
    var title: String { return question }
    var options: [String] { return answers }
}
