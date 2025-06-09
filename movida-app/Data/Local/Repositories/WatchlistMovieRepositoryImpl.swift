//
//  WatchlistMovieRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

class WatchlistMovieRepositoryImpl: WatchlistMovieRepository {
    private let realmService: WatchlistService
    
    init(realmService: WatchlistService) {
        self.realmService = realmService
    }
    
    func getWatchlistMovies() async throws -> [WatchlistMovie] {
        let objects = try await realmService.getWatchlistMovies()
        return objects.map { WatchlistMovie(id: $0.id, title: $0.title, imageUrl: $0.imageUrl) }
    }
    
    func addMovieToWatchlist(movie: WatchlistMovie) async throws {
        let object = WatchlistMovieObject(id: movie.id.isEmpty ? UUID().uuidString : movie.id, title: movie.title, imageUrl: movie.imageUrl, addedAt: Date())
        try await realmService.addMovieToWatchlist(movie: object)
    }
    
    func removeMovieFromWatchlist(id: String) async throws {
        try await realmService.removeMovieFromWatchlist(id: id)
    }
    
    func isInWatchlist(id: String) async -> Bool {
        return await realmService.isMovieInWatchlist(id: id)
    }
}
