//
//  MoviePosterDataProvider.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - MoviePosterDataProvider (Ensure this is defined in a shared place or imported)
// For TV Shows, 'movieTitle' maps to 'name', 'movieYear' maps to 'firstAirDate'.
// Ideally, consider renaming this to a more general 'MediaPosterDataProvider'
// or creating a specific 'TVShowPosterDataProvider' if the distinction is important.
//protocol MoviePosterDataProvider: Identifiable, Hashable {
//    var posterURL: URL? { get }
//    var movieTitle: String { get } // Will map to TV show name
//    var movieYear: String? { get } // Will map to TV show first air year
//    var id: Int { get }
//}


// MARK: - TVShow (Domain/Entity Model)
struct TVShow: Identifiable, Hashable, MoviePosterDataProvider {
    let id: Int
    let name: String // TV show name
    let originalName: String
    let overview: String
    let firstAirDateString: String? // Storing raw date for year extraction
    let posterPathString: String?
    let backdropPathString: String?
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let genreIDs: [Int]
    let originCountry: [String]
    let originalLanguage: String

    // Conformance to MoviePosterDataProvider
    var posterURL: URL? {
        guard let path = posterPathString else { return nil }
        // Adjust base URL and size as per your TMDB API usage
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }

    var movieTitle: String {
        return self.name // Using 'name' for the display title
    }

    var movieYear: String? {
        guard let dateString = firstAirDateString, !dateString.isEmpty else { return nil }
        // Safely extract the year from "YYYY-MM-DD"
        return String(dateString.prefix(4))
    }

    // Initializer to convert from DTO to Domain model
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

    // MARK: - Static Example for Previews
    static let example = TVShow(from: PopularTVShowResultDTO(
        backdropPath: "/mAJ84W6I8I272Da87qplS2Dp9ST.jpg",
        firstAirDate: "2023-01-23",
        genreIds: [9648, 18],
        id: 202250,
        name: "Dirty Linen",
        originCountry: ["PH"],
        originalLanguage: "tl",
        originalName: "Dirty Linen",
        overview: "To exact vengeance, a young woman infiltrates the household of an influential family as a housemaid to expose their dirty secrets. However, love will get in the way of her revenge plot.",
        popularity: 2797.914,
        posterPath: "/aoAZgnmMzY9vVy9VWnO3U5PZENh.jpg",
        voteAverage: 5,
        voteCount: 13
    ))
}
