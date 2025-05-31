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
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure(let error):
                Text("Failed: \(error.localizedDescription)")
                    .foregroundColor(.red)
                    .padding()
            case .success:
                if let movie = viewModel.movieDetail {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            YouTubePlayerView(movie: movie)
                            MovieMetadataView(movie: movie)
                            MovieSynopsisView(movie: movie)
                        }
                        .padding(.bottom)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMovieDetail(id: movieId)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - YouTube Player View
private struct YouTubePlayerView: View {
    let movie: MovieDetail
    @State private var showPlayer = false
    
    var body: some View {
        VStack(spacing: 0) {
            if showPlayer {
                YouTubeWebView(videoId: getYouTubeVideoId())
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            } else {
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
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
            }
            
            if showPlayer {
                HStack(spacing: 20) {
                    Button("Close Player") {
                        showPlayer = false
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("Trailer")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
    }
    
    private func getYouTubeVideoId() -> String {
        return "WLmY9icEOQk"
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

private struct RelatedMoviesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Related Movies")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 120, height: 180)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
