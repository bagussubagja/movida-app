//
//  FavoriteServiceImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

enum FavoriteServiceError: Error {
    case userNotLoggedIn
    case failedToGetData
}

class FavoriteServiceImpl: FavoriteService {
    private let db = Firestore.firestore()
    
    private func getFavoritesCollection() throws -> CollectionReference {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FavoriteServiceError.userNotLoggedIn
        }
        return db.collection("users").document(userId).collection("favorites")
    }
    
    func getFavoriteMovies() async throws -> [FavoriteMovieDTO] {
        let favoritesCollection = try getFavoritesCollection()
        
        return try await favoritesCollection
            .order(by: "addedAt", descending: true)
            .getDocuments()
            .documents
            .compactMap { try? $0.data(as: FavoriteMovieDTO.self) }
    }
    
    func addFavoriteMovie(movie: FavoriteMovieDTO) async throws {
        let favoritesCollection = try getFavoritesCollection()
        try favoritesCollection.document(movie.movieId).setData(from: movie)
    }

    func removeFavoriteMovie(movieId: String) async throws {
        let favoritesCollection = try getFavoritesCollection()
        try await favoritesCollection.document(movieId).delete()
    }
    
    func isMovieFavorite(movieId: String) async throws -> Bool {
        let favoritesCollection = try getFavoritesCollection()
        let docRef = favoritesCollection.document(movieId)
        let document = try await docRef.getDocument()
        return document.exists
    }
}
