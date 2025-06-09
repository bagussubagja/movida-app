//
//  FavoriteService.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation
import FirebaseFirestore

protocol FavoriteService {
    func getFavoriteMovies() async throws -> [FavoriteMovieDTO]
    func addFavoriteMovie(movie: FavoriteMovieDTO) async throws
    func removeFavoriteMovie(movieId: String) async throws
    func isMovieFavorite(movieId: String) async throws -> Bool
}
