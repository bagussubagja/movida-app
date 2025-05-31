//
//  VideoResponseDTO.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - VideoResponseDTO
struct MovieVideoResponseDTO: Decodable {
    let id: Int
    let results: [VideoResultDTO]
    
    func toDomain() -> [MovieVideo] {
        return results.map { MovieVideo(from: $0) }
    }
}

// MARK: - VideoResultDTO
struct VideoResultDTO: Decodable {
    let iso639_1: String
    let iso3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String

    // Custom CodingKeys to map JSON keys to Swift property names
    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}
