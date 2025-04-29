//
//  SaleScreenViewController.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit
import SnapKit
import StoreKit

final class SaleScreenViewController: UIViewController {

    var onCloseSaleScreen: (() -> Void)?
    
    // Add ViewModel
    private let viewModel = SaleScreenViewModel()
    
    // Add loading indicator
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // Анімація успішної покупки
    private let successCheckmark: UIImageView = {
        let imageView = UIImageView()
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .semibold)
            let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)
            imageView.image = image
            imageView.tintColor = .systemGreen
        } else {
            // Для старих версій iOS можна використовувати звичайне зображення
            imageView.backgroundColor = .systemGreen
            imageView.layer.cornerRadius = 30
        }
        imageView.alpha = 0
        imageView.isHidden = true
        return imageView
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
            let image = UIImage(systemName: "xmark", withConfiguration: config)
            button.setImage(image, for: .normal)
            button.tintColor = UIConstants.secondaryText
        } else {
            button.setTitle("×", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
            button.setTitleColor(UIConstants.secondaryText, for: .normal)
        }

        return button
    }()

    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(named: "PremiumImage")
        return imageView
    }()

    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover all\nPremium features"
        label.font = UIConstants.titleFont
        label.textColor = UIConstants.primaryText
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let subheadlineLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIConstants.secondaryText
        label.numberOfLines = 2

        let text = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        let attributedString = NSMutableAttributedString(string: text)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))

        attributedString.addAttribute(.font,
                                      value: UIConstants.bodyFont,
                                      range: NSRange(location: 0, length: attributedString.length))

        let priceRange = (text as NSString).range(of: "$6.99")
        if priceRange.location != NSNotFound {
            attributedString.addAttribute(.font,
                                          value: UIFont.systemFont(ofSize: 16, weight: .bold),
                                          range: priceRange)
        }

        label.attributedText = attributedString
        label.textAlignment = .left
        return label
    }()

    private let disclaimerTextView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.dataDetectorTypes = [.link]
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textAlignment = .center

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: UIConstants.smallFont,
            .foregroundColor: UIConstants.secondaryText.withAlphaComponent(0.6),
            .paragraphStyle: paragraphStyle
        ]

        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: UIConstants.linkFont,
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: 0,
            .paragraphStyle: paragraphStyle
        ]

        let attributedString = NSMutableAttributedString(string: "By continuing you accept our:\n", attributes: regularAttributes)

        let termsText = NSMutableAttributedString(string: "Terms of Use", attributes: linkAttributes)
        termsText.addAttribute(.link,
                               value: "https://www.apple.com/legal/internet-services/terms/site.html",
                               range: NSRange(location: 0, length: termsText.length))
        attributedString.append(termsText)

        attributedString.append(NSAttributedString(string: ", ", attributes: regularAttributes))

        let privacyText = NSMutableAttributedString(string: "Privacy Policy", attributes: linkAttributes)
        privacyText.addAttribute(.link,
                                 value: "https://www.apple.com/legal/privacy/",
                                 range: NSRange(location: 0, length: privacyText.length))
        attributedString.append(privacyText)

        attributedString.append(NSAttributedString(string: ", ", attributes: regularAttributes))

        let subscriptionText = NSMutableAttributedString(string: "Subscription Terms", attributes: linkAttributes)
        subscriptionText.addAttribute(.link,
                                      value: "https://developer.apple.com/support/terms/",
                                      range: NSRange(location: 0, length: subscriptionText.length))
        attributedString.append(subscriptionText)

        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: 0
        ]

        textView.attributedText = attributedString
        return textView
    }()

    private let startNowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = UIConstants.activeButton
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 28
        button.layer.shadowColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: -4)
        button.layer.shadowRadius = 36 / 2
        button.layer.shadowOpacity = 1
        button.clipsToBounds = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPremiumImage()
        
        // Preload subscription products
        loadProducts()
    }

    private func setupUI() {
        view.backgroundColor = UIConstants.background

        view.addSubview(heroImageView)
        view.addSubview(closeButton)
        view.addSubview(headlineLabel)
        view.addSubview(subheadlineLabel)
        view.addSubview(startNowButton)
        view.addSubview(disclaimerTextView)
        view.addSubview(activityIndicator)
        view.addSubview(successCheckmark)

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right).inset(16)
            make.width.height.equalTo(44)
        }

        heroImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(1.1)
        }

        headlineLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        subheadlineLabel.snp.makeConstraints { make in
            make.top.equalTo(headlineLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        startNowButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(327)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(disclaimerTextView.snp.top).offset(-16)
        }

        disclaimerTextView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(startNowButton)
        }
        
        successCheckmark.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }

        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        startNowButton.addTarget(self, action: #selector(startNowButtonTapped), for: .touchUpInside)
    }

    private func setupPremiumImage() {
        if heroImageView.image == nil {
            let path = Bundle.main.path(forResource: "PremiumImage", ofType: "jpg")
            if let path = path, let image = UIImage(contentsOfFile: path) {
                heroImageView.image = image
            } else {
                print("Failed to load PremiumImage.jpg")
                heroImageView.backgroundColor = UIColor.lightGray
            }
        }
        view.bringSubviewToFront(closeButton)
    }

    private func loadProducts() {
        // Показуємо індикатор завантаження
        activityIndicator.startAnimating()
        startNowButton.isEnabled = false
        
        viewModel.loadProducts { [weak self] result in
            // Зупиняємо індикатор завантаження
            self?.activityIndicator.stopAnimating()
            self?.startNowButton.isEnabled = true
            
            switch result {
            case .success(let products):
                print("Successfully loaded \(products.count) subscription products")
                // Активуємо кнопку покупки, якщо продукти завантажені успішно
                self?.startNowButton.isEnabled = true
            case .failure(let error):
                print("Failed to load products: \(error.localizedDescription)")
                if let storeError = error as? StoreKitManager.StoreError, storeError == .notAvailable {
                    self?.showAlert(title: "Products Unavailable", message: "Could not load subscription options. Please make sure that you have an active internet connection and try again later.")
                } else {
                    self?.showAlert(title: "Products Unavailable", message: "Could not load subscription options. Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showSuccessAnimation(completion: @escaping () -> Void) {
        successCheckmark.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.successCheckmark.alpha = 1
        }) { _ in
            // Затримка перед зникненням
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.successCheckmark.alpha = 0
                }) { _ in
                    self.successCheckmark.isHidden = true
                    completion()
                }
            }
        }
    }

    @objc private func closeButtonTapped() {
        onCloseSaleScreen?()
    }

    @objc private func startNowButtonTapped() {
        startNowButton.isEnabled = false
        activityIndicator.startAnimating()
        
        viewModel.purchaseWeeklySubscription { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success:
                    print("Successfully purchased subscription")
                    self?.showSuccessAnimation {
                        self?.onCloseSaleScreen?()
                    }
                    
                case .failure(let error):
                    self?.startNowButton.isEnabled = true
                    
                    if let storeError = error as? StoreKitManager.StoreError {
                        switch storeError {
                        case .userCancelled:
                            print("User cancelled the purchase")
                        case .pending:
                            self?.showAlert(title: "Purchase Pending", message: "Your purchase is being processed and will be available soon.")
                        case .verificationFailed:
                            self?.showAlert(title: "Verification Failed", message: "We couldn't verify your purchase. Please try again later.")
                        case .notAvailable:
                            self?.showAlert(title: "Product Unavailable", message: "This subscription is currently unavailable. Please try again later.")
                        case .unknown:
                            self?.showAlert(title: "Purchase Failed", message: "An unknown error occurred. Please try again later.")
                        }
                    } else {
                        print("Purchase failed with error: \(error.localizedDescription)")
                        self?.showAlert(title: "Purchase Failed", message: "Could not complete your subscription. Please try again later.")
                    }
                }
            }
        }
    }
}
