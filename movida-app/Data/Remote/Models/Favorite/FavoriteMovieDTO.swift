//
//  FavoriteMovieDTO.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation
import FirebaseFirestore
import FirebaseCore

struct FavoriteMovieDTO: Codable, Identifiable {
    @DocumentID var id: String?
    let title: String
    let imageUrl: String
    let addedAt: Date
    let movieId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl
        case addedAt
        case movieId
    }
}
