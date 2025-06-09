//
//  CheckIsInWatchlistUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class CheckIsInWatchlistUseCase {
    private let repository: WatchlistMovieRepository
    
    init(repository: WatchlistMovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async -> Bool {
        return await repository.isInWatchlist(id: id)
    }
}
