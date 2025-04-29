//
//  OnboardingViewController.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    var onOnboardingFinished: (() -> Void)?
    private let viewModel = OnboardingViewModel()
    
    private var onboardingData: [OnboardingModel] = []
    private var currentStepIndex: Int = 0
    private var selectedOption: Int?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's setup App for you"
        label.font = UIConstants.titleFont
        label.textColor = UIConstants.primaryText
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.secondTitleFont
        label.textColor = UIConstants.secondaryText
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let continueButton: ContinueButton = {
        let button = ContinueButton()
        button.setTitle("Continue", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadOnboardingData()
    }
    
    private func bindViewModel() {
        viewModel.onDataLoaded = { [weak self] data in
            guard let self = self else { return }
            self.onboardingData = data
            self.showCurrentStep()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIConstants.background

        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(optionsStackView)
        view.addSubview(continueButton)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }

        optionsStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.width.equalTo(327)
        }

        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }

        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    private func showCurrentStep() {
        guard !onboardingData.isEmpty, currentStepIndex < onboardingData.count else {
            onOnboardingFinished?()
            return
        }
        
        let currentStep = onboardingData[currentStepIndex]
        titleLabel.text = "Let's setup App for you"
        subtitleLabel.text = currentStep.title
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, option) in currentStep.options.enumerated() {
            let optionButton = OnboardingOptionButton()
            optionButton.title = option
            optionButton.tag = index
            optionButton.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            optionsStackView.addArrangedSubview(optionButton)
        }
        
        selectedOption = nil
        continueButton.isEnabled = false
    }
    
    @objc private func optionSelected(_ sender: OnboardingOptionButton) {
        selectedOption = sender.tag
        
        optionsStackView.arrangedSubviews.forEach { view in
            if let optionButton = view as? OnboardingOptionButton {
                optionButton.isSelected = (optionButton.tag == selectedOption)
            }
        }
        
        continueButton.isEnabled = true
    }
    
    @objc private func didTapContinue() {
        if currentStepIndex == onboardingData.count - 1 {
            onOnboardingFinished?()
        } else {
            currentStepIndex += 1
            showCurrentStep()
        }
    }
}
