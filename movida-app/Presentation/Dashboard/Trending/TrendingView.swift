//
//  TrendingView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct TrendingView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = TrendingViewModel()

    private let trendingContentHeight: CGFloat = 180
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack(spacing: 8) {
                    Text("Stream")
                        .font(.title)
                        .foregroundColor(AppColors.orangeAccent)
                    Text("Everywhere")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                ContinueWatchingCardView(
                    imageURL: URL(string: Constant.placeholderImage),
                    title: "Ready Player one",
                    subtitle: "Continue Watching"
                )
                
                SpaceBox(height: 16)
                
                Text("Trending")
                    .font(.title2)
                    .foregroundColor(.white)
                
                VStack {
                    switch viewModel.state {
                    case .loading:
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(0..<5) { _ in
                                    TrendingMovieShimmerView()
                                }
                            }
                            .padding(.leading)
                        }
                        .frame(height: trendingContentHeight)
                        
                    case .success:
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(viewModel.trendingMovies) { movie in
                                    Button(action: {
                                        navigationPath.append(AppRoute.detail(String(movie.id)))
                                    }) {
                                        TrendingMovieCardView(
                                            title: movie.title,
                                            rating: movie.voteAverage,
                                            imageURL: movie.fullPosterURL
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                }
                            }
                            .padding(.horizontal)
                        }
                        
                    case .failure(let error):
                        VStack {
                            Spacer()
                            Text("Failed to load trending movies.")
                                .foregroundColor(.red)
                            Text(error.localizedDescription)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: trendingContentHeight, alignment: .center)
    
                    default:
                        VStack {
                            Spacer()
                            Text("Loading data or an unexpected state occurred.")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity) // Allow centering
                        .frame(height: trendingContentHeight, alignment: .center)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .onAppear {
            viewModel.fetchTrendingMovies()
        }
    }
}

struct TrendingMovieShimmerView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
        .fill(Color.gray.opacity(0.3))
        .frame(width: 120, height: 180)
        .shimmering()
    }
}
