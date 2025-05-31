//
//  ContinueWatchingCardView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct ContinueWatchingCardView: View {
    let imageURL: URL?
    let title: String
    let subtitle: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(height: 200)
            }
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            
           
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.red, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        .frame(width: 40, height: 40)
                    Image(systemName: "play.fill")
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(subtitle)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.subheadline)
                    Text(title)
                        .foregroundColor(.white)
                        .font(.title3).bold()
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(16)
        }
        .frame(maxWidth: .infinity)
    }
}
