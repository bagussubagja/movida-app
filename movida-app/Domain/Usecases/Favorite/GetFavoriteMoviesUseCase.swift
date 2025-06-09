//
//  GetFavoriteMoviesUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class GetFavoriteMoviesUseCase {
    private let repository: FavoriteMovieRepository
    
    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [FavoriteMovie] {
        try await repository.getFavoriteMovies()
    }
}