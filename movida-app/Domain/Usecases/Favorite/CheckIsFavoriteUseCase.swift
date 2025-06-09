//
//  CheckIsFavoriteUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class CheckIsFavoriteUseCase {
    private let repository: FavoriteMovieRepository
    
    init(repository: FavoriteMovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async -> Bool {
        return (try? await repository.isFavorite(id: id)) ?? false
    }
}
