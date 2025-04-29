//
//  ContinueButton.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit
import SnapKit

final class ContinueButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 28
        
        layer.shadowColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        layer.shadowOffset = CGSize(width: 0, height: -4)
        layer.shadowRadius = 18
        layer.shadowOpacity = 1
        clipsToBounds = false

        snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(327)
        }

        updateAppearance()
    }

    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted && isEnabled {
                backgroundColor = UIConstants.activeButton.withAlphaComponent(0.9)
            } else {
                updateAppearance()
            }
        }
    }

    private func updateAppearance() {
        if isEnabled {
            backgroundColor = UIConstants.activeButton
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = UIColor.white
            setTitleColor(UIColor(hex: "CACACA"), for: .normal) 
        }
    }
}
