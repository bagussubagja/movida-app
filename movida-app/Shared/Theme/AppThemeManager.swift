//
//  AppThemeManager.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI
import Combine

class AppThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true {
        didSet {
            objectWillChange.send()
        }
    }

    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
