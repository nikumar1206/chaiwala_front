//
//  Colors.swift
//  chaiwala
//
//  Created by Nikhil Kumar on 4/11/25.
//
import SwiftUI


// Extension to create colors from hex values
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


class CustomColor {
    let deepAmber = Color(hex: "C17A0F")      // Primary color - rich tea
    let softChai = Color(hex: "B98A3E")           // New Primary - soft amber chai tone
    let warmCream = Color(hex: "F7F3E3")          // Secondary - milk tone
    let cinnamonBrown = Color(hex: "8C4A2F")      // Accent - warm depth
    let forestGreen = Color(hex: "2D4739")        // Accent - tea leaves
    let terracotta = Color(hex: "BF6B63")         // Accent - subtle highlight
    let backgroundCream = Color(hex: "FAF7F2")    // Background - light and calming
    let orangeAccent = Color(hex: "#FF9933")
    let malai = Color(hex: "#FFF6E5")
    let saffronGold = Color(hex: "E6B653")
    let cardamomGreen = Color(hex: "3F5E49")
    let kadakGreen = Color(hex: "2B3F32")
    let kashmiriPink = Color(hex: "E7B2AC")
}
let ChaiColors = CustomColor()

let deepAmber = Color(hex: "C17A0F")      // Primary color - rich tea
let softChai = Color(hex: "B98A3E")           // New Primary - soft amber chai tone
let warmCream = Color(hex: "F7F3E3")          // Secondary - milk tone
let cinnamonBrown = Color(hex: "8C4A2F")      // Accent - warm depth
let forestGreen = Color(hex: "2D4739")        // Accent - tea leaves
let terracotta = Color(hex: "BF6B63")         // Accent - subtle highlight
let backgroundCream = Color(hex: "FAF7F2")    // Background - light and calming
let orangeAccent = Color(hex: "#FF9933")
