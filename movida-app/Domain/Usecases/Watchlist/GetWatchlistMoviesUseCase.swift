//
//  GetWatchlistMoviesUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class GetWatchlistMoviesUseCase {
    private let repository: WatchlistMovieRepository
    
    init(repository: WatchlistMovieRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [WatchlistMovie] {
        try await repository.getWatchlistMovies()
    }
}