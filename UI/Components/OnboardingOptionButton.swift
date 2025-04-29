//
//  OnboardingOptionButton.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit
import SnapKit

final class OnboardingOptionButton: UIControl {

    private let titleLabel = UILabel()

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIConstants.highlight
            } else {
                updateAppearance()
            }
        }
    }

    private func setupUI() {
        backgroundColor = UIConstants.cardBackground
        layer.cornerRadius = 12
        setupTitleLabel()
        
        layer.shadowColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.0).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3.5
        layer.shadowOpacity = 1
        clipsToBounds = false
        
        updateAppearance()

        snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(327)
        }
    }

    private func setupTitleLabel() {
        titleLabel.font = UIConstants.subtitleFont
        titleLabel.textColor = UIConstants.primaryText
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .left

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = UIConstants.selection
            titleLabel.textColor = .white
        } else {
            backgroundColor = UIConstants.cardBackground
            titleLabel.textColor = UIConstants.primaryText
        }
    }
}
