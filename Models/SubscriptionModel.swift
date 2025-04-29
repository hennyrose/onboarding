//
//  SubscriptionModel.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import StoreKit

struct SubscriptionModel {
    let product: Product
    
    var id: String {
        return product.id
    }
    
    var displayPrice: String {
        return product.displayPrice
    }
    
    var displayName: String {
        return product.displayName
    }
    
    var description: String {
        return product.description
    }
}
