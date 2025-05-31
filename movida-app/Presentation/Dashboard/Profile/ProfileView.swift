//
//  ProfileView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct ProfileView: View {
    
    let user = UserProfile(
        name: "Bagus Subagja",
        username: "@bagussubagja",
        profileImage: "person.circle.fill",
        moviesWatched: 154,
        hoursWatched: 312,
        watchlistCount: 23
    )
    
    let favoriteMovies = [
        MovieItemModel(title: "Dune: Part Two", imageUrl: "https://image.tmdb.org/t/p/w500/8b8R8l88Qje9dn9OE8PY05Nxl1X.jpg"),
        MovieItemModel(title: "Interstellar", imageUrl: "https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"),
        MovieItemModel(title: "The Dark Knight", imageUrl: "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
        MovieItemModel(title: "Parasite", imageUrl: "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg")
    ]
    
    let watchlist = [
        MovieItemModel(title: "Oppenheimer", imageUrl: "https://image.tmdb.org/t/p/w500/8Gxv8gSFCU0XGDykEGv7zR1n2ua.jpg"),
        MovieItemModel(title: "Poor Things", imageUrl: "https://image.tmdb.org/t/p/w500/kCGlA_y0g3RshN1I1hYI4T7IIFh.jpg"),
        MovieItemModel(title: "Spider-Man: Across the Spider-Verse", imageUrl: "https://image.tmdb.org/t/p/w500/8Vt6mWEReuy4Of61Lp5Sj74xUh8.jpg"),
        MovieItemModel(title: "The Creator", imageUrl: "https://image.tmdb.org/t/p/w500/vBZ0qvaRxqEhZwl6LWmruJqWE8A.jpg")
    ]

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    ProfileHeaderView(user: user)
                    
                    StatsView(user: user)
                    
                    MovieCarouselView(title: "Favorite Movies", movies: favoriteMovies)
                    
                    MovieCarouselView(title: "My Watchlist", movies: watchlist)
                    
                    SettingsView()
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("My Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Subviews

struct ProfileHeaderView: View {
    let user: UserProfile
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: user.profileImage)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct StatsView: View {
    let user: UserProfile
    
    var body: some View {
        HStack {
            StatItemView(count: user.moviesWatched, label: "Movies Watched")
            Spacer()
            StatItemView(count: user.hoursWatched, label: "Hours Watched")
            Spacer()
            StatItemView(count: user.watchlistCount, label: "In Watchlist")
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct StatItemView: View {
    let count: Int
    let label: String
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct MovieCarouselView: View {
    let title: String
    let movies: [MovieItemModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(movies) { movie in
                        AsyncImage(url: URL(string: movie.imageUrl)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 130, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 0) {
            SettingsRow(title: "Edit Profile", icon: "person.fill")
            Divider().background(Color.gray.opacity(0.3))
            SettingsRow(title: "Notifications", icon: "bell.fill")
            Divider().background(Color.gray.opacity(0.3))
            SettingsRow(title: "Privacy & Security", icon: "lock.shield.fill")
            Divider().background(Color.gray.opacity(0.3))
            SettingsRow(title: "Help & Support", icon: "questionmark.circle.fill")
            Divider().background(Color.gray.opacity(0.3))
            LogoutButton()
        }
        .background(Color.gray.opacity(0.15))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            HStack {
                Label(title, systemImage: icon)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

struct LogoutButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Label("Log Out", systemImage: "arrow.right.square.fill")
                    .foregroundColor(.red)
                Spacer()
            }
            .padding()
        }
    }
}


struct UserProfile {
    let name: String
    let username: String
    let profileImage: String
    let moviesWatched: Int
    let hoursWatched: Int
    let watchlistCount: Int
}

struct MovieItemModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let imageUrl: String
}


// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().preferredColorScheme(.dark)
    }
}
