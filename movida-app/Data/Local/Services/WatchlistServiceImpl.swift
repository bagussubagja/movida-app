//
//  WatchlistServiceImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//

import Foundation
import RealmSwift

class WatchlistServiceImpl: WatchlistService {
    private var realm: Realm {
        try! Realm()
    }

    func getWatchlistMovies() async throws -> [WatchlistMovieObject] {
        let results = realm.objects(WatchlistMovieObject.self).sorted(byKeyPath: "addedAt", ascending: false)
        return Array(results)
    }
    
    func addMovieToWatchlist(movie: WatchlistMovieObject) async throws {
        try realm.write {
            realm.add(movie, update: .modified)
        }
    }
    
    func removeMovieFromWatchlist(id: String) async throws {
        if let movieObject = realm.object(ofType: WatchlistMovieObject.self, forPrimaryKey: id) {
            try realm.write {
                realm.delete(movieObject)
            }
        }
    }
    
    func isMovieInWatchlist(id: String) async -> Bool {
        return realm.object(ofType: WatchlistMovieObject.self, forPrimaryKey: id) != nil
    }
}
