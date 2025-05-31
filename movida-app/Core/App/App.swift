//
//  App.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI
import SwiftData

@main
struct movida_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var themeManager = AppThemeManager()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.colorScheme)
        }
    }
}

