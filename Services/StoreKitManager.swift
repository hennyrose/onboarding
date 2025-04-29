
//
//  StoreKitManager.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import StoreKit

final class StoreKitManager {
    static let shared = StoreKitManager()
    
    private init() {}

    func fetchSubscriptions() async throws -> [SubscriptionModel] {
        let productIDs = [Constants.Subscriptions.weeklyID]
        print("Attempting to fetch products with IDs: \(productIDs)")
        
        let products = try await Product.products(for: productIDs)
        
        if products.isEmpty {
            print("WARNING: No products were found for IDs: \(productIDs)")
            throw StoreError.notAvailable
        }
        
        print("Successfully loaded \(products.count) products")
        for product in products {
            print("Product: ID=\(product.id), Price=\(product.displayPrice)")
        }
        
        return products.map { SubscriptionModel(product: $0) }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        print("Attempting to purchase product: \(product.id)")

        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                print("Transaction verified successfully")
                await transaction.finish()
                return transaction
            case .unverified:
                print("Transaction verification failed")
                throw StoreError.verificationFailed
            }
        case .userCancelled:
            print("User cancelled the purchase")
            throw StoreError.userCancelled
        case .pending:
            print("Purchase is pending")
            throw StoreError.pending
        @unknown default:
            print("Unknown purchase result")
            throw StoreError.unknown
        }
    }
    
    enum StoreError: Error {
        case verificationFailed
        case userCancelled
        case pending
        case unknown
        case notAvailable
    }
}
