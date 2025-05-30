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
    
    var body: some Scene {
        WindowGroup {
            RootRouter()
        }
    }
}
