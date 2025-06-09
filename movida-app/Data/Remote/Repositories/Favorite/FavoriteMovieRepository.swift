//
//  FavoriteMovieRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

protocol FavoriteMovieRepository {
    func getFavoriteMovies() async throws -> [FavoriteMovie]
    func addFavoriteMovie(movie: FavoriteMovie) async throws
    func removeFavoriteMovie(id: String) async throws
    func isFavorite(id: String) async throws -> Bool
}
