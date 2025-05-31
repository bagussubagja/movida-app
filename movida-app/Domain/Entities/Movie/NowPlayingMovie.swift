//
//  MoviePosterDataProvider.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - MoviePosterDataProvider (Ensure this is defined in a shared place or imported)
// protocol MoviePosterDataProvider: Identifiable, Hashable {
//     var posterURL: URL? { get }
//     var movieTitle: String { get }
//     var movieYear: String? { get }
//     var id: Int { get }
// }


// MARK: - NowPlayingMovie (Domain/Entity Model)
struct NowPlayingMovie: Identifiable, Hashable, MoviePosterDataProvider {
    let id: Int
    let title: String
    let overview: String
    let posterPathString: String?
    let backdropPathString: String?
    let releaseDateString: String?
    let voteAverage: Double
    let genreIDs: [Int]
    let adult: Bool
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool

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

    init(from dto: NowPlayingMovieResultDTO) {
        self.id = dto.id
        self.title = dto.title
        self.overview = dto.overview ?? "No overview available."
        self.posterPathString = dto.posterPath
        self.backdropPathString = dto.backdropPath
        self.releaseDateString = dto.releaseDate
        self.voteAverage = dto.voteAverage
        self.genreIDs = dto.genreIds
        self.adult = dto.adult
        self.originalLanguage = dto.originalLanguage
        self.originalTitle = dto.originalTitle
        self.popularity = dto.popularity
        self.video = dto.video
    }

}
