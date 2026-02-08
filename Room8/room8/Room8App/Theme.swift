//
//  Theme.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

// MARK: - Theme
enum Theme {
    // Your palette
    static let navy  = Color(hex: "4C4F64")
    static let sage  = Color(hex: "88B6A0")
    static let bg    = Color(hex: "FAEAD4")
    static let sand  = Color(hex: "F9E1BB")
    static let terracotta = Color(hex: "BC6F5D")

    // Neutrals
    static let white = Color.white
    static let black = Color.black

    // Layout
    static let cornerXL: CGFloat = 22
    static let cornerL: CGFloat = 18
    static let cornerM: CGFloat = 14
    static let pad: CGFloat = 20
}

// MARK: - Hex init
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}
