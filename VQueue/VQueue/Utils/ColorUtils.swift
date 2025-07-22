//
//  ColorUtils.swift
//  Muvo
//
//  Created by Frengky Gunawan on 10/06/25.
//
import SwiftUI

extension Color {
    static let primaryColor = Color(hex: "#DB2181")
    static let secondaryColor = Color(hex: "#EA79B3")
    static let accentColor = Color(hex: "#F28322")
    static let whiteColor = Color(hex: "#FFFFFF")
    static let blackColor = Color(hex: "#0D0D0D")
    static let redColor = Color(hex: "#DB284E")
    static let grayColor = Color(hex: "#E9E9EA")
    static let iconGrayColor = Color(hex: "#838384")
    static let dividerColor = Color(hex: "#B2B2B2")
    static let graysColor = Color(hex: "#8E8E93")
}

extension Color {
    init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        
        guard hex.count == 6,
              let intCode = Int(hex, radix: 16) else {
            return nil
        }

        let red = Double((intCode >> 16) & 0xFF) / 255.0
        let green = Double((intCode >> 8) & 0xFF) / 255.0
        let blue = Double(intCode & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
