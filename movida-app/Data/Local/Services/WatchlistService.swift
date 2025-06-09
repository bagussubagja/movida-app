//
//  WatchlistRealmServiceProtocol.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation
import RealmSwift

protocol WatchlistService {
    func getWatchlistMovies() async throws -> [WatchlistMovieObject]
    func addMovieToWatchlist(movie: WatchlistMovieObject) async throws
    func removeMovieFromWatchlist(id: String) async throws
    func isMovieInWatchlist(id: String) async -> Bool
}

