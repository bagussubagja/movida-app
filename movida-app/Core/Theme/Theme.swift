//
//  Theme.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//


import SwiftUI

enum Theme: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
