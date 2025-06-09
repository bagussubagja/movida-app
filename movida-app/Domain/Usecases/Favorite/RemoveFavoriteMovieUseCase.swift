//
//  RemoveFavoriteMovieUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class RemoveFavoriteMovieUseCase {
    private let repository: FavoriteMovieRepository
    
    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        try await repository.removeFavoriteMovie(id: id)
    }
}
