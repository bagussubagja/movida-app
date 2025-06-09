//
//  CustomMovieCardView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct CustomMovieCardView: View {
    let title: String
    let year: String
    let imageUrl: String

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(2/3, contentMode: .fill)
                    .cornerRadius(20)
            } placeholder: {
                Color.gray.opacity(0.3)
                    .aspectRatio(2/3, contentMode: .fill)
                    .cornerRadius(20)
            }
               .frame(height: 240)
               .frame(maxWidth: .infinity)
               .clipped()
            Text(title)
                .font(.headline)
                .lineLimit(1)
            Text("(\(year))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}
