//
//  HomeView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText: String = ""
    @State private var selectedTab: TabCategory = .movies
    @FocusState private var isSearchFocused: Bool

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Find Movies, TV series, and more..")
                    .font(.title.bold())
                    .padding(.horizontal)

                CustomTextField(text: $searchText, placeholder: "Sherlock Holmes")
                    .focused($isSearchFocused)

                if !isSearchFocused && searchText.isEmpty {
                    CustomTabBarView(selected: $selectedTab)
                        .padding(.horizontal)
                }
                content
            }
            .padding(.top)
            .onTapGesture {
                    isSearchFocused = false
                }
        }
        .onAppear {
            loadCurrentTab()
        }
        .onChange(of: selectedTab) { _ in
            loadCurrentTab()
        }
        .onChange(of: searchText) { newValue in
            if !newValue.isEmpty {
                viewModel.searchMovies(query: newValue)
            } else {
                viewModel.searchResults = []
            }
        }
    }

    private func loadCurrentTab() {
        switch selectedTab {
        case .movies:
            viewModel.fetchNowPlayingMovies()
        case .tvSeries:
            viewModel.fetchAiredTvShows()
        }
    }

    @ViewBuilder
    private var content: some View {
        if isSearchFocused || (!searchText.isEmpty && !viewModel.searchResults.isEmpty) {
            searchResultsView
        } else {
            switch selectedTab {
            case .movies:
                contentForMovies
            case .tvSeries:
                contentForTVShows
            }
        }
    }

    @ViewBuilder
    private var contentForMovies: some View {
        switch viewModel.movieState {
        case .loading:
            ProgressView().padding()
        case .failure(let error):
            Text("Failed to load movies: \(error.localizedDescription)").foregroundColor(.red).padding()
        case .success, .idle:
            movieGridView
        }
    }

    @ViewBuilder
    private var contentForTVShows: some View {
        switch viewModel.tvState {
        case .loading:
            ProgressView().padding()
        case .failure(let error):
            Text("Failed to load TV shows: \(error.localizedDescription)").foregroundColor(.red).padding()
        case .success, .idle:
            tvGridView
        }
    }

    private var movieGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.nowPlaying) { movie in
                MovieGridItem(movie: movie, navigationPath: $navigationPath)
            }
        }
        .padding(.horizontal)
    }

    private var tvGridView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.airedTVShows) { show in
                TVGridItem(tvShow: show)
            }
        }
        .padding(.horizontal)
    }

    private var searchResultsView: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
            ForEach(viewModel.searchResults) { movie in
                SearchGridItem(movie: movie, navigationPath: $navigationPath)
            }
        }
        .padding(.horizontal)
    }
}

struct SearchGridItem: View {
    let movie: MovieSearch
    @Binding var navigationPath: NavigationPath

    var body: some View {
        let year = String(movie.releaseDateString?.prefix(4) ?? "")
        let imageUrl = Constant.imageBaseURL + (movie.posterPathString ?? "")

        Button {
            navigationPath.append(AppRoute.detail(String(movie.id)))
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)

                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct MovieGridItem: View {
    let movie: NowPlayingMovie
    @Binding var navigationPath: NavigationPath

    var body: some View {
        let year = String(movie.releaseDateString?.prefix(4) ?? "")
        let imageUrl = Constant.imageBaseURL + (movie.posterPathString ?? "")

        Button {
            navigationPath.append(AppRoute.detail(String(movie.id)))
        } label: {
            CustomMovieCardView(title: movie.title, year: year, imageUrl: imageUrl)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TVGridItem: View {
    let tvShow: TVShow

    var body: some View {
        let year = String(tvShow.firstAirDateString?.prefix(4) ?? "")
        let imageUrl = Constant.imageBaseURL + (tvShow.posterPathString ?? "")

        Button {
            // Navigasi TV Show jika perlu
        } label: {
            CustomMovieCardView(title: tvShow.name, year: year, imageUrl: imageUrl)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
