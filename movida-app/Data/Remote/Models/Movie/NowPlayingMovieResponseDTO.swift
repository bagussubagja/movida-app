//
//  NowPlayingMovieResponseDTO.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - NowPlayingMovieResponseDTO
struct NowPlayingMovieResponseDTO: Decodable {
    let dates: DatesDTO
    let page: Int
    let results: [NowPlayingMovieResultDTO]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    func toDomain() -> [NowPlayingMovie] {
        return results.map { NowPlayingMovie(from: $0) }
    }
}

// MARK: - DatesDTO
struct DatesDTO: Decodable {
    let maximum: String
    let minimum: String
}

// MARK: - NowPlayingMovieResultDTO
struct NowPlayingMovieResultDTO: Decodable {
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
