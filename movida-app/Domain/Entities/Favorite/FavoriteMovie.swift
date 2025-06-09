//
//  FavoriteMovie.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

struct FavoriteMovie: Identifiable, Equatable {
    let id: String
    let title: String
    let imageUrl: String
    let movieId: String
}
