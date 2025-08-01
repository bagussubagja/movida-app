//
//  MovieDetailResponseDTO.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - MovieDetailResponseDTO
struct MovieDetailResponseDTO: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: CollectionDTO?
    let budget: Int
    let genres: [GenreDTO]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompanyDTO]
    let productionCountries: [ProductionCountryDTO]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguageDTO]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    struct CollectionDTO: Codable {
        let id: Int
        let name: String
        let posterPath: String?
        let backdropPath: String?

        enum CodingKeys: String, CodingKey {
            case id, name
            case posterPath = "poster_path"
            case backdropPath = "backdrop_path"
        }
    }

    struct GenreDTO: Codable {
        let id: Int
        let name: String
    }

    struct ProductionCompanyDTO: Codable {
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String

        enum CodingKeys: String, CodingKey {
            case id
            case logoPath = "logo_path"
            case name
            case originCountry = "origin_country"
        }
    }

    struct ProductionCountryDTO: Codable {
        let iso3166_1: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case iso3166_1 = "iso_3166_1"
            case name
        }
    }

    struct SpokenLanguageDTO: Codable {
        let englishName: String
        let iso639_1: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case englishName = "english_name"
            case iso639_1 = "iso_639_1"
            case name
        }
    }
}
