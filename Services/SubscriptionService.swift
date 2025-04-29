//
//  SubscriptionService.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 29/04/2025.
//

import StoreKit

@available(iOS 15.0, *)
final class SubscriptionService {
    static let shared = SubscriptionService()
    
    private init() {}
    
    func fetchSubscriptions() async throws -> [Product] {
        return try await Product.products(for: [Constants.Subscriptions.weeklyID])
    }
    
    func purchaseSubscription(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                await transaction.finish()
                return transaction
            case .unverified:
                throw SubscriptionError.verificationFailed
            }
        case .userCancelled:
            throw SubscriptionError.userCancelled
        case .pending:
            throw SubscriptionError.paymentPending
        @unknown default:
            throw SubscriptionError.unknown
        }
    }
    
    enum SubscriptionError: Error {
        case noProductsFound
        case verificationFailed
        case userCancelled
        case paymentPending
        case unknown
    }
}
