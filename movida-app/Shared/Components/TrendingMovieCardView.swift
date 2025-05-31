//
//  MovieCardView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct TrendingMovieCardView: View {
    let title: String
    let rating: Double
    let imageURL: URL?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 260)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 180, height: 260)
            }
            .cornerRadius(24)
            .overlay(
                HStack(spacing: 6) {
                    Text("IMDb")
                        .font(.caption)
                        .foregroundColor(.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text(String(format: "%.1f", rating))
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(10),
                alignment: .topTrailing
            )
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(10)
        }
        .frame(width: 180, height: 260)
    }
}
