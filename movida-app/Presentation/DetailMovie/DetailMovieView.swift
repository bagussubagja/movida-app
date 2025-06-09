//  DetailMovieView.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import SwiftUI
import WebKit

struct DetailMovieView: View {
    @Binding var navigationPath: NavigationPath
    let movieId: String
    
    @StateObject private var viewModel = DetailMovieViewModel()

    var body: some View {
        Group {
            switch (viewModel.detailState, viewModel.videoState) {
            case (.idle, _), (.loading, _), (_, .loading) where viewModel.movieDetail == nil:
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Tampilkan error jika fetch detail gagal
            case (.failure(let error), _):
                ErrorView(error: error) {
                    viewModel.fetchMovieData(id: movieId)
                }
            case (_, .failure(let error)) where viewModel.movieDetail == nil:
                 ErrorView(error: error) {
                    viewModel.fetchMovieData(id: movieId)
                }
            case (.success, _):
                if let movie = viewModel.movieDetail {
                    successView(for: movie)
                }
            }
        }
        .onAppear {
            if viewModel.movieDetail == nil {
                viewModel.onAppear(movieId: movieId)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func successView(for movie: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                YouTubePlayerView(
                    movie: movie,
                    videos: viewModel.movieVideos,
                    isVideoLoading: viewModel.isVideoLoading,
                    videoError: viewModel.videoError,
                    isInWatchlist: viewModel.isInWatchlist,
                    onPlayVideo: {
                        viewModel.addToWatchlist()
                    },
                    onAddToWatchlist: {
                        viewModel.addToWatchlist()
                    }
                )
                MovieMetadataView(movie: movie, viewModel: viewModel)
                MovieSynopsisView(movie: movie)
                DiscoverSectionView(
                    navigationPath: $navigationPath, similarMovies: viewModel.similarMovies,
                    similarMovieState: viewModel.similarMovieState
                )
            }
            .padding(.bottom)
        }
    }
}

private struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle).foregroundColor(.yellow)
            Text("Terjadi Kesalahan").font(.headline)
            Text(error.localizedDescription).font(.caption).foregroundColor(.secondary)
                .multilineTextAlignment(.center).padding(.horizontal)
            Button("Coba Lagi", action: retry).buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct YouTubePlayerView: View {
    let movie: MovieDetail
    let videos: [MovieVideo]
    let isVideoLoading: Bool
    let videoError: Error?
    let isInWatchlist: Bool
    var onPlayVideo: () -> Void
    var onAddToWatchlist: () -> Void
    
    @State private var showPlayer = false
    @State private var selectedVideoIndex = 0
    
    private var availableVideos: [MovieVideo] {
        videos.filter { $0.isYouTube && ($0.isTrailer || $0.isTeaser) }
              .sorted { $0.isTrailer && !$1.isTeaser }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if showPlayer && !availableVideos.isEmpty {
                YouTubeWebView(videoId: availableVideos[selectedVideoIndex].key)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            } else {
                ZStack {
                    AsyncImage(url: movie.fullBackdropURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { Color.gray.opacity(0.3) }
                    .frame(height: 220).clipped()
                
                    
                    VStack(spacing: 16) {
                        if isVideoLoading {
                            ProgressView().tint(.white)
                        } else if videoError != nil || availableVideos.isEmpty {
                            Image(systemName: "play.slash.fill").font(.largeTitle).foregroundColor(.white.opacity(0.7))
                            
                            if !isInWatchlist {
                                Button(action: onAddToWatchlist) {
                                    Label("Add to Watchlist", systemImage: "bookmark")
                                        .font(.headline).foregroundColor(.white).padding(.horizontal, 16)
                                        .padding(.vertical, 10).background(Color.blue.opacity(0.9))
                                        .clipShape(Capsule())
                                }
                            }
                        } else {
                            Button(action: {
                                withAnimation { showPlayer = true }
                                onPlayVideo()
                            }) {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                    .background(.black.opacity(0.3), in: Circle())
                                    .shadow(radius: 10)
                            }
                        }
                    }
                }
                .frame(height: 220).clipShape(RoundedRectangle(cornerRadius: 12)).padding(.horizontal)
            }
        }
    }
}

private struct MovieMetadataView: View {
    let movie: MovieDetail
    @ObservedObject var viewModel: DetailMovieViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(movie.title)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title2).foregroundColor(viewModel.isFavorite ? .red : .gray)
                        .padding(8).background(.ultraThinMaterial, in: Circle())
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.isFavorite)
            }

            HStack(spacing: 16) {
                if let runtime = movie.runtime, runtime > 0 {
                    Label("\(runtime) minutes", systemImage: "clock")
                }
                Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
            }
            .font(.caption).foregroundColor(.secondary)
            

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(movie.genres, id: \.id) { genre in
                        Text(genre.name)
                            .font(.caption).padding(.horizontal, 8).padding(.vertical, 4)
                            .background(Color.gray.opacity(0.2)).cornerRadius(8)
                    }
                }
            }
        }.padding(.horizontal)
    }
}

private struct MovieSynopsisView: View {
    let movie: MovieDetail
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis").font(.headline)
            Text(movie.overview).font(.body).foregroundColor(.secondary)
        }.padding(.horizontal)
    }
}

private struct DiscoverSectionView: View {
    @Binding var navigationPath: NavigationPath
    let similarMovies: [SimilarMovie]
    let similarMovieState: SimilarMovieViewState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discover More").font(.headline).padding(.horizontal)
            switch similarMovieState {
            case .loading:
                ProgressView().padding(.horizontal)
            case .failure:
                Text("Failed to fetch movies data").font(.caption).foregroundColor(.red).padding(.horizontal)
            case .success where similarMovies.isEmpty:
                Text("Similar movie not found").font(.caption).foregroundColor(.secondary).padding(.horizontal)
            case .success:
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(similarMovies, id: \.id) { movie in
                            SimilarMovieCard(
                                navigationPath: $navigationPath,
                                movie: movie
                            )
                        }
                    }.padding(.horizontal)
                }
            default:
                EmptyView()
            }
        }
    }
}

private struct SimilarMovieCard: View {
    @Binding var navigationPath: NavigationPath
    let movie: SimilarMovie
    
    var body: some View {
        Button(action: {
            navigationPath.append(AppRoute.detail(String(movie.id)))
        }) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: movie.posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo.fill").foregroundColor(.gray)
                    default:
                        ProgressView()
                    }
                }
                .frame(width: 120, height: 180)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.caption.bold())
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(width: 120)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

private struct YouTubeWebView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <!DOCTYPE html><html><head><style>
        body { margin:0; padding:0; background:black; }
        .video-container { position:relative; width:100%; height:0; padding-bottom:56.25%; }
        .video-container iframe { position:absolute; top:0; left:0; width:100%; height:100%; }
        </style></head><body><div class="video-container">
        <iframe src="https://www.youtube.com/embed/\(videoId)?playsinline=1&showinfo=0&rel=0&controls=1"
        frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
        </div></body></html>
        """
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}
