
//
//  SaleScreenViewModel.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import StoreKit

final class SaleScreenViewModel {
    
    typealias PurchaseCompletion = (Result<Transaction?, Error>) -> Void
    typealias ProductsCompletion = (Result<[SubscriptionModel], Error>) -> Void
    
    private(set) var subscriptions: [SubscriptionModel] = []
    
    func loadProducts(completion: @escaping ProductsCompletion) {
        Task {
            do {
                print("SaleScreenViewModel: Attempting to load products...")
                let products = try await StoreKitManager.shared.fetchSubscriptions()
                self.subscriptions = products
                
                await MainActor.run {
                    print("SaleScreenViewModel: Products loaded successfully, count: \(products.count)")
                    completion(.success(products))
                }
            } catch {
                print("SaleScreenViewModel: Failed to load products: \(error)")
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func purchaseSubscription(productId: String, completion: @escaping PurchaseCompletion) {
        Task {
            do {
                print("SaleScreenViewModel: Attempting to purchase product with ID: \(productId)")
                
                if subscriptions.isEmpty {
                    let products = try await StoreKitManager.shared.fetchSubscriptions()
                    self.subscriptions = products
                }
                
                if let subscription = subscriptions.first(where: { $0.id == productId }) {
                    let transaction = try await StoreKitManager.shared.purchase(subscription.product)
                    
                    await MainActor.run {
                        print("SaleScreenViewModel: Purchase successful")
                        completion(.success(transaction))
                    }
                } else {
                    print("SaleScreenViewModel: Product with ID \(productId) not found")
                    await MainActor.run {
                        completion(.failure(StoreKitManager.StoreError.notAvailable))
                    }
                }
            } catch {
                print("SaleScreenViewModel: Purchase failed with error: \(error)")
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func purchaseWeeklySubscription(completion: @escaping PurchaseCompletion) {
        purchaseSubscription(productId: Constants.Subscriptions.weeklyID, completion: completion)
    }
}
