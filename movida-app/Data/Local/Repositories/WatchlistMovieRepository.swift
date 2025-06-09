//
//  WatchlistMovieRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation

protocol WatchlistMovieRepository {
    func getWatchlistMovies() async throws -> [WatchlistMovie]
    func addMovieToWatchlist(movie: WatchlistMovie) async throws
    func removeMovieFromWatchlist(id: String) async throws
    func isInWatchlist(id: String) async -> Bool
}
