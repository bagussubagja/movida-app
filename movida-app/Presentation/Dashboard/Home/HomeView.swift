//
//  HomeView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct HomeView: View {
    @Binding var navigationPath: NavigationPath
    @State private var searchText: String = ""
    @State private var selectedTab: TabCategory = .movies

    let sampleMovies = [
        ("Soul", "2020"),
        ("Knives Out", "2019"),
        ("Onward", "2020"),
        ("Mulan", "2020"),
        ("Barudak", "2021"),
        ("Mahiwal", "2019"),
        ("Bebas", "2020"),
        ("Malam", "2020"),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                Text("Find Movies, TV series, and more..")
                    .font(.title.bold())
                    .padding(.horizontal)
                
                CustomTextField(text: $searchText, placeholder: "Sherlock Holmes")
                
                CustomTabBarView(selected: $selectedTab)
                                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(sampleMovies, id: \.0) { movie in
                        Button {} label: {
                            CustomMovieCardView(title: movie.0, year: movie.1, imageUrl: Constant.placeholderImage)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}
