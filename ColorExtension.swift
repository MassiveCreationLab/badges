//
//  ColorExtension.swift
//  time
//
//  Created by MassiveCreationLab on 12.01.26.
//

import SwiftUI

extension Color {
    static func badgeColor(for count: Int) -> Color {
        switch count {
        case 0: return Color(red: 0.72, green: 0.45, blue: 0.20) // copper
        case 1: return Color(red: 0.75, green: 0.75, blue: 0.78) // silver
        case 2: return Color(red: 0.90, green: 0.75, blue: 0.25) // gold
        default: return Color(red: 0.35, green: 0.20, blue: 0.55) // dark purple
        }
    }
}
