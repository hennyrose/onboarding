//
//  OnboardingCardView.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 24/04/2025.
//

import UIKit
import SnapKit

final class OnboardingCardView: UIView {

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(title: String, description: String, imageUrl: String?) {
        titleLabel.text = title
        descriptionLabel.text = description

        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
          
            imageView.backgroundColor = .systemGray6
        }
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = Constants.Layout.cardCornerRadius
        layer.masksToBounds = true

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.numberOfLines = 1

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}
