//
//  RootRouter.swift
//  movida-app
//
//  Created by Bagus Subagja on 25/05/25.
//


import SwiftUI

struct RootRouter: View {
    @State private var path = NavigationPath()
    @StateObject private var themeManager = AppThemeManager()

    var body: some View {
        NavigationStack(path: $path) {
            DashboardView(navigationPath: $path)
        }
    }
}

struct DetailRoute: Hashable {
    let title: String
    let subtitle: String
}
