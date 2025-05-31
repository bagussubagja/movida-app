//  DetailMovieView.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import SwiftUI
import WebKit

struct DetailMovieView: View {
    let movieId: String
    @StateObject private var viewModel = DetailMovieViewModel()

    var body: some View {
        Group {
            switch (viewModel.detailState, viewModel.videoState) {
            case (.idle, _), (.loading, _), (_, .loading):
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case (.failure(let error), _):
                ErrorView(error: error) {
                    viewModel.fetchMovieDetail(id: movieId)
                }
            case (_, .failure(let error)) where viewModel.movieDetail == nil:
                ErrorView(error: error) {
                    viewModel.fetchMovieVideos(id: movieId)
                }
            case (.success, _):
                if let movie = viewModel.movieDetail {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            YouTubePlayerView(
                                movie: movie,
                                videos: viewModel.movieVideos,
                                isVideoLoading: viewModel.isVideoLoading,
                                videoError: viewModel.videoError
                            )
                            MovieMetadataView(movie: movie)
                            MovieSynopsisView(movie: movie)
                            DiscoverSectionView(
                                similarMovies: viewModel.similarMovies,
                                similarMovieState: viewModel.similarMovieState
                            )
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMovieData(id: movieId)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Error View
private struct ErrorView: View {
    let error: Error
    let retry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(error.localizedDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                retry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

// MARK: - YouTube Player View
private struct YouTubePlayerView: View {
    let movie: MovieDetail
    let videos: [MovieVideo]
    let isVideoLoading: Bool
    let videoError: Error?
    
    @State private var showPlayer = false
    @State private var selectedVideoIndex = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if showPlayer && !availableVideos.isEmpty {
                VStack(spacing: 12) {
                    YouTubeWebView(videoId: availableVideos[selectedVideoIndex].key)
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                    
                    // Video selector if multiple videos available
                    if availableVideos.count > 1 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(availableVideos.enumerated()), id: \.offset) { index, video in
                                    VideoSelectorButton(
                                        video: video,
                                        isSelected: index == selectedVideoIndex
                                    ) {
                                        selectedVideoIndex = index
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            } else {
                // Poster/Backdrop with play button
                ZStack {
                    if let posterURL = movie.fullBackdropURL {
                        AsyncImage(url: posterURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 220)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 220)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 220)
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    // Play button overlay
                    VStack {
                        if isVideoLoading {
                            ProgressView()
                                .tint(.white)
                        } else if videoError != nil || availableVideos.isEmpty {
                            // Show disabled play button if no videos or error
                            Circle()
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "play.slash.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                )
                        } else {
                            Button(action: {
                                showPlayer = true
                            }) {
                                Circle()
                                    .fill(Color.black.opacity(0.6))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "play.fill")
                                            .foregroundColor(.white)
                                            .font(.title2)
                                    )
                            }
                        }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            
            // Control buttons
            if showPlayer || videoError != nil {
                HStack(spacing: 20) {
                    if showPlayer {
                        Button("Close Player") {
                            showPlayer = false
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    if let currentVideo = availableVideos.first {
                        Text(currentVideo.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    } else if videoError != nil {
                        Text("Videos unavailable")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
    }
    
    private var availableVideos: [MovieVideo] {
        videos.filter { $0.isYouTube && ($0.isTrailer || $0.isTeaser) }
            .sorted { (first: MovieVideo, second: MovieVideo) -> Bool in
                // Prioritize trailers over teasers
                if first.isTrailer && second.isTeaser {
                    return true
                } else if first.isTeaser && second.isTrailer {
                    return false
                }
                // Then sort by published date (newest first)
                return first.publishedAt > second.publishedAt
            }
    }
}

// MARK: - Video Selector Button
private struct VideoSelectorButton: View {
    let video: MovieVideo
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(video.type)
                    .font(.caption2.bold())
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(video.name)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .white : .secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
            )
        }
        .frame(width: 100)
    }
}

// MARK: - YouTube WebView
struct YouTubeWebView: UIViewRepresentable {
    let videoId: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body { margin: 0; padding: 0; background: black; }
                .video-container {
                    position: relative;
                    width: 100%;
                    height: 0;
                    padding-bottom: 56.25%; /* 16:9 aspect ratio */
                }
                .video-container iframe {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                }
            </style>
        </head>
        <body>
            <div class="video-container">
                <iframe 
                    src="https://www.youtube.com/embed/\(videoId)?autoplay=0&playsinline=1&controls=1&showinfo=0&rel=0"
                    frameborder="0"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen>
                </iframe>
            </div>
        </body>
        </html>
        """
        
        uiView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

private struct MovieMetadataView: View {
    let movie: MovieDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(movie.title)
                    .font(.title2.bold())
                Spacer()
                Text("4K")
                    .font(.caption.bold())
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(6)
            }

            HStack(spacing: 16) {
                if let runtime = movie.runtime {
                    Label("\(runtime) minutes", systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Label(String(format: "%.1f", movie.voteAverage), systemImage: "star.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider()

            HStack {
                VStack(alignment: .leading) {
                    Text("Release date")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(movie.releaseDate)
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("Genre")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        ForEach(movie.genres, id: \.id) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Discover Section View
private struct DiscoverSectionView: View {
    let similarMovies: [SimilarMovie]
    let similarMovieState: SimilarMovieViewState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Discover")
                .font(.headline)
                .padding(.horizontal)
            
            switch similarMovieState {
            case .idle:
                EmptyView()
            case .loading:
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading similar movies...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            case .failure(let error):
                VStack(alignment: .leading, spacing: 8) {
                    Text("Failed to load similar movies")
                        .font(.caption)
                        .foregroundColor(.red)
                    Text(error.localizedDescription)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            case .success:
                if similarMovies.isEmpty {
                    Text("No similar movies found")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(similarMovies, id: \.id) { movie in
                                SimilarMovieCard(movie: movie)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// MARK: - Similar Movie Card
private struct SimilarMovieCard: View {
    let movie: SimilarMovie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 180)
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.8)
                        )
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                case .failure:
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 180)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                                .font(.title2)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.caption.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text(String(format: "%.1f", movie.voteAverage))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(movie.releaseDateString ?? "")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 120)
    }
}

private struct MovieSynopsisView: View {
    let movie: MovieDetail

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Synopsis")
                .font(.headline)

            Text(movie.overview)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
    }
}
