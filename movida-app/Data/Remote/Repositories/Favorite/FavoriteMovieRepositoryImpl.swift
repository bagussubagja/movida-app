//
//  FavoriteMovieRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//

import Foundation

class FavoriteMovieRepositoryImpl: FavoriteMovieRepository {
    private let firestoreService: FavoriteService
    
    init(firestoreService: FavoriteService) {
        self.firestoreService = firestoreService
    }
    
    func getFavoriteMovies() async throws -> [FavoriteMovie] {
        let dtos = try await firestoreService.getFavoriteMovies()
        return dtos.compactMap { dto in
            guard let id = dto.id else { return nil }
            return FavoriteMovie(id: id, title: dto.title, imageUrl: dto.imageUrl, movieId: dto.movieId)
        }
    }
    
    func addFavoriteMovie(movie: FavoriteMovie) async throws {
        let dto = FavoriteMovieDTO(id: movie.id, title: movie.title, imageUrl: movie.imageUrl, addedAt: Date(), movieId: movie.movieId)
        try await firestoreService.addFavoriteMovie(movie: dto)
    }
    
    func removeFavoriteMovie(id: String) async throws {
        try await firestoreService.removeFavoriteMovie(movieId: id)
    }
    
    func isFavorite(id: String) async throws -> Bool {
        return try await firestoreService.isMovieFavorite(movieId: id)
    }
}
