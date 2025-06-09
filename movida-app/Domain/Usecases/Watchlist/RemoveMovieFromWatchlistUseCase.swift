//
//  RemoveMovieFromWatchlistUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class RemoveMovieFromWatchlistUseCase {
    private let repository: WatchlistMovieRepository
    
    init(repository: WatchlistMovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        try await repository.removeMovieFromWatchlist(id: id)
    }
}
