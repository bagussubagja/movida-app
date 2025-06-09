//
//  AddFavoriteMovieUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class AddFavoriteMovieUseCase {
    private let repository: FavoriteMovieRepository
    
    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }
    
    func execute(movie: FavoriteMovie) async throws {
        try await repository.addFavoriteMovie(movie: movie)
    }
}
