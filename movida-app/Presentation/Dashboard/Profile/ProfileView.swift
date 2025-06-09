//
//  ProfileView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var themeManager: AppThemeManager
    @State private var showingInfoPage: InfoPage?
    
    @StateObject private var viewModel: ProfileViewModel
    var onSignOut: () -> Void

    init(navigationPath: Binding<NavigationPath>, onSignOut: @escaping () -> Void) {
        self._navigationPath = navigationPath
        self.onSignOut = onSignOut
        self._viewModel = StateObject(wrappedValue: ProfileViewModel())
    }

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()

            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
            case .success:
                successView
            case .failure(let error):
                errorView(error: error)
            }
        }
        .navigationTitle("My Profile")
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .sheet(item: $showingInfoPage) { page in
            NavigationView {
                InformationView(title: page.title, content: page.content)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Done") { showingInfoPage = nil }
                        }
                    }
                    .preferredColorScheme(themeManager.colorScheme)
            }
        }
    }
    
    private var successView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 32) {
                Text("My Profile").font(.title2.bold()).padding(.top)

                if let user = viewModel.user {
                    ProfileHeaderView(email: user.email, name: user.email?.components(separatedBy: "@").first ?? "User")
                }
                
                StatsView(
                    favoriteCount: viewModel.favoriteMovies.count,
                    watchlistCount: viewModel.watchlistMovies.count
                )
                
                // Section Favorite
                SectionView(
                    title: "Favorite Movies",
                    movies: viewModel.favoriteMovies.map { MovieItemModel(id: $0.movieId, title: $0.title, imageUrl: $0.imageUrl) },
                    emptyState: EmptyStateView(iconName: "heart.slash.fill", title: "No Favorites Yet", subtitle: "Movies you mark as favorite will appear here."),
                    navigationPath: $navigationPath
                )
                
                // Section Watchlist
                SectionView(
                    title: "Watchlist",
                    movies: viewModel.watchlistMovies.map { MovieItemModel(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) },
                    emptyState: EmptyStateView(iconName: "bookmark.slash.fill", title: "Empty Watchlist", subtitle: "Movies you add to watch later will appear here."),
                    navigationPath: $navigationPath
                )

                SettingsView(
                    themeManager: themeManager,
                    onShowInfoPage: { pageType in self.showingInfoPage = InfoPage(type: pageType) },
                    onSignOut: {
                        Task {
                            try? await viewModel.signOut()
                            onSignOut()
                        }
                    }
                )
                Spacer()
                SpaceBox(height: 50)
            }
            .padding(.vertical)
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 50)).foregroundColor(.yellow)
            Text("Failed to Load Data").font(.headline)
            Text(error.localizedDescription).font(.caption).foregroundColor(.gray).multilineTextAlignment(.center).padding(.horizontal)
            Button("Try Again") { viewModel.onAppear() }.buttonStyle(.borderedProminent)
        }
    }
}

private struct ProfileHeaderView: View {
    let email: String?
    let name: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill").font(.system(size: 80)).foregroundColor(.secondary)
            Text(name).font(.title.bold())
            Text(email ?? "").font(.subheadline).foregroundColor(.secondary)
        }.padding()
    }
}

private struct StatsView: View {
    let favoriteCount: Int
    let watchlistCount: Int
    
    var body: some View {
        HStack {
            Spacer()
            StatItemView(count: favoriteCount, label: "Favorites")
            Spacer()
            StatItemView(count: watchlistCount, label: "Watchlist")
            Spacer()
        }
        .padding().background(.regularMaterial).cornerRadius(16).padding(.horizontal)
    }
}

private struct StatItemView: View {
    let count: Int
    let label: String
    var body: some View {
        VStack {
            Text("\(count)").font(.title3).fontWeight(.bold)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}

private struct SectionView<EmptyState: View>: View {
    let title: String
    let movies: [MovieItemModel]
    let emptyState: EmptyState
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title).font(.headline).padding(.horizontal)
            if movies.isEmpty {
                emptyState
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(movies) { movie in
                            Button(action: { navigationPath.append(AppRoute.detail(movie.id)) }) {
                                AsyncImage(url: URL(string: movie.imageUrl)) { image in image.resizable() }
                                placeholder: { Color.secondary.opacity(0.3) }
                                .frame(width: 130, height: 180).clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }.padding(.horizontal)
                }
            }
        }
    }
}

private struct EmptyStateView: View {
    let iconName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName).font(.system(size: 44)).foregroundColor(.secondary.opacity(0.6))
            VStack(spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity).padding(.vertical, 32).background(.regularMaterial)
        .cornerRadius(16).padding(.horizontal)
    }
}

private struct SettingsView: View {
    @ObservedObject var themeManager: AppThemeManager
    var onShowInfoPage: (InfoPage.PageType) -> Void
    var onSignOut: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text("Settings").font(.headline).padding(.horizontal)
            VStack(spacing: 0) {
                Toggle(isOn: $themeManager.isDarkMode) { Label("Dark Mode", systemImage: "moon.fill") }
                    .tint(.red).padding()
                Divider().background(Color.gray.opacity(0.3))
                SettingsRow(title: "Privacy Policy", icon: "lock.shield.fill") { onShowInfoPage(.privacyPolicy) }
                Divider().background(Color.gray.opacity(0.3))
                SettingsRow(title: "Help & Support", icon: "questionmark.circle.fill") { onShowInfoPage(.helpAndSupport) }
                Divider().background(Color.gray.opacity(0.3))
                SettingsRow(title: "Log Out", icon: "arrow.right.square.fill", isDestructive: true, action: onSignOut)
            }
            .background(.regularMaterial).cornerRadius(16)
        }
        .padding(.horizontal)
    }
}

private struct SettingsRow: View {
    let title: String
    let icon: String
    var isDestructive: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Label(title, systemImage: icon).foregroundColor(isDestructive ? .red : .primary)
                Spacer()
                if !isDestructive { Image(systemName: "chevron.right").foregroundColor(.secondary) }
            }.padding()
        }
    }
}

private struct InfoPage: Identifiable {
    let id = UUID()
    let type: PageType
    
    var title: String { type.title }
    var content: String { type.content }
    
    enum PageType {
        case privacyPolicy, helpAndSupport
        
        var title: String {
            switch self {
            case .privacyPolicy: return "Privacy Policy"
            case .helpAndSupport: return "Help & Support"
            }
        }
        
        var content: String {
            switch self {
            case .privacyPolicy:
                return """
                # Privacy Policy for Movida App
                **Last Updated: June 10, 2025**
                
                Welcome to Movida App! Your privacy is important to us.
                
                ## Information We Collect
                - **Account Information:** When you create an account, we collect your email address.
                - **Usage Data:** We collect information about how you use the app, such as your favorite movies and watchlist.
                
                ## How We Use Your Information
                We use the information we collect to:
                - Provide and maintain our service.
                - Personalize your experience.
                - Communicate with you about updates.
                
                """
            case .helpAndSupport:
                return """
                # Help & Support
                
                Having trouble with Movida App? We're here to help!
                
                ## Frequently Asked Questions
                **Q: How do I add a movie to my favorites?**
                A: On the movie detail page, tap the heart icon to add it to your favorites.
                
                **Q: How do I change the theme?**
                A: You can change the theme from the Settings section on your profile page.
                
                ## Contact Us
                If you need further assistance, please email us at:
                **support@movida-app.com**
                """
            }
        }
    }
}

struct MovieItemModel: Identifiable, Hashable {
    let id: String
    let title: String
    let imageUrl: String
}
