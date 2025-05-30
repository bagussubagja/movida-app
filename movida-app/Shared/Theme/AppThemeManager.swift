//
//  AppThemeManager.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI
import Combine

class AppThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }

    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }

    func toggle() {
        isDarkMode.toggle()
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
