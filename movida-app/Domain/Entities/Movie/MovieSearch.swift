//
//  is.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation


// MARK: - MovieSearch (Domain/Entity Model)
/// Represents a movie specifically obtained from a search operation in the application's domain layer.
struct MovieSearch: Identifiable, Hashable, MoviePosterDataProvider {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDateString: String? // Store the raw date string
    let posterPathString: String?
    let backdropPathString: String?
    let adult: Bool
    let video: Bool
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let genreIDs: [Int]
    let originalLanguage: String

    // MARK: - MoviePosterDataProvider Conformance

    var posterURL: URL? {
        guard let path = posterPathString else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var movieTitle: String {
        return self.title
    }

    var movieYear: String? {
        guard let dateString = releaseDateString, !dateString.isEmpty else { return nil }
        return String(dateString.prefix(4))
    }

    // MARK: - Initialization

    /// Initializes a `MovieSearch` entity from a `MovieSearchResultDTO`.
    init(from dto: MovieSearchResultDTO) {
        self.id = dto.id
        self.title = dto.title
        self.originalTitle = dto.originalTitle
        self.overview = dto.overview ?? "No overview available."
        self.releaseDateString = dto.releaseDate
        self.posterPathString = dto.posterPath
        self.backdropPathString = dto.backdropPath
        self.adult = dto.adult
        self.video = dto.video
        self.popularity = dto.popularity
        self.voteAverage = dto.voteAverage
        self.voteCount = dto.voteCount
        self.genreIDs = dto.genreIds
        self.originalLanguage = dto.originalLanguage
    }
}
