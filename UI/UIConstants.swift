//
//  UIConstants.swift
//  OnboardingApp
//
//  Created by Igor Rozovetskiy on 28/04/2025.
//

import UIKit

struct UIConstants {
    static let titleFont = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let secondTitleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
    static let subtitleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let bodyFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    static let smallFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let linkFont = UIFont.systemFont(ofSize: 12, weight: .regular)
    
    static let primaryText = UIColor(hex: "#1A1A1A")
    static let secondaryText = UIColor(hex: "#3C3C43")
    static let background = UIColor(hex: "#F7F7F8")
    static let cardBackground = UIColor(hex: "#FBFCFF")
    static let disabledButton = UIColor(hex: "#F2F2F7")
    static let activeButton = UIColor(hex: "#0C2615")
    static let selection = UIColor(hex: "#47BE9A")
    static let highlight = UIColor(hex: "#E5E5EA")
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


