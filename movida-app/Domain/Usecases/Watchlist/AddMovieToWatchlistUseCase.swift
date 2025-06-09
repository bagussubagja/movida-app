//
//  AddMovieToWatchlistUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class AddMovieToWatchlistUseCase {
    private let repository: WatchlistMovieRepository
    
    init(repository: WatchlistMovieRepository) {
        self.repository = repository
    }
    
    func execute(movie: WatchlistMovie) async throws {
        try await repository.addMovieToWatchlist(movie: movie)
    }
}
