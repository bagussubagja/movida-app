//
//  MoviePosterDataProvider.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

struct TVShow: Identifiable, Hashable, MoviePosterDataProvider {
    let id: Int
    let name: String
    let originalName: String
    let overview: String
    let firstAirDateString: String?
    let posterPathString: String?
    let backdropPathString: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let genreIDs: [Int]
    let originCountry: [String]
    let originalLanguage: String

    var posterURL: URL? {
        guard let path = posterPathString else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var movieTitle: String {
        return self.name
    }

    var movieYear: String? {
        guard let dateString = firstAirDateString, !dateString.isEmpty else { return nil }
        return String(dateString.prefix(4))
    }

    init(from dto: PopularTVShowResultDTO) {
        self.id = dto.id
        self.name = dto.name
        self.originalName = dto.originalName
        self.overview = dto.overview ?? "No overview available."
        self.firstAirDateString = dto.firstAirDate
        self.posterPathString = dto.posterPath
        self.backdropPathString = dto.backdropPath
        self.popularity = dto.popularity
        self.voteAverage = dto.voteAverage
        self.voteCount = dto.voteCount
        self.genreIDs = dto.genreIds
        self.originCountry = dto.originCountry
        self.originalLanguage = dto.originalLanguage
    }
}
