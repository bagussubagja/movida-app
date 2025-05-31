//
//  Movie.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - Movie
struct Movie: Identifiable, Equatable, Hashable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let title: String
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: String
    let genreIds: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    var fullPosterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
    var fullBackdropURL: URL? {
        if let path = backdropPath {
            return URL(string: "https://image.tmdb.org/t/p/w1280\(path)")
        }
        return nil
    }

    static func fromDTO(_ dto: MovieResponseDTO) -> Movie {
        Movie(
            id: dto.id,
            adult: dto.adult,
            backdropPath: dto.backdropPath,
            title: dto.title,
            originalLanguage: dto.originalLanguage,
            originalTitle: dto.originalTitle,
            overview: dto.overview,
            posterPath: dto.posterPath,
            mediaType: dto.mediaType,
            genreIds: dto.genreIds,
            popularity: dto.popularity,
            releaseDate: dto.releaseDate,
            video: dto.video,
            voteAverage: dto.voteAverage,
            voteCount: dto.voteCount
        )
    }
}
