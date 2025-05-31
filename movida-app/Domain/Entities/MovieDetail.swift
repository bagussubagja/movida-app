//
//  MovieDetail.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation

// MARK: - MovieDetail
struct MovieDetail: Identifiable, Equatable, Hashable {
    let id: Int
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: URL?
    let imdbID: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    struct Collection: Equatable, Hashable {
        let id: Int
        let name: String
        let posterPath: String?
        let backdropPath: String?
        
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
    }

    struct Genre: Identifiable, Equatable, Hashable {
        let id: Int
        let name: String
    }

    struct ProductionCompany: Identifiable, Equatable, Hashable {
        let id: Int
        let logoPath: String?
        let name: String
        let originCountry: String
        
        var fullLogoURL: URL? {
            if let path = logoPath {
                return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            }
            return nil
        }
    }

    struct ProductionCountry: Equatable, Hashable {
        let iso3166_1: String
        let name: String
    }

    struct SpokenLanguage: Equatable, Hashable {
        let englishName: String
        let iso639_1: String
        let name: String
    }
    
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
}

// MARK: - Mapping Extension for MovieDetailResponseDTO
extension MovieDetailResponseDTO {
    func toDomain() -> MovieDetail {
        MovieDetail(
            id: self.id,
            adult: self.adult,
            backdropPath: self.backdropPath,
            belongsToCollection: self.belongsToCollection?.toDomain(),
            budget: self.budget,
            genres: self.genres.map { $0.toDomain() },
            homepage: self.homepage.flatMap { URL(string: $0) },
            imdbID: self.imdbID,
            originCountry: self.originCountry,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            productionCompanies: self.productionCompanies.map { $0.toDomain() },
            productionCountries: self.productionCountries.map { $0.toDomain() },
            releaseDate: self.releaseDate,
            revenue: self.revenue,
            runtime: self.runtime,
            spokenLanguages: self.spokenLanguages.map { $0.toDomain() },
            status: self.status,
            tagline: self.tagline,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}

extension MovieDetailResponseDTO.CollectionDTO {
    func toDomain() -> MovieDetail.Collection {
        MovieDetail.Collection(
            id: self.id,
            name: self.name,
            posterPath: self.posterPath,
            backdropPath: self.backdropPath
        )
    }
}

extension MovieDetailResponseDTO.GenreDTO {
    func toDomain() -> MovieDetail.Genre {
        MovieDetail.Genre(
            id: self.id,
            name: self.name
        )
    }
}

extension MovieDetailResponseDTO.ProductionCompanyDTO {
    func toDomain() -> MovieDetail.ProductionCompany {
        MovieDetail.ProductionCompany(
            id: self.id,
            logoPath: self.logoPath,
            name: self.name,
            originCountry: self.originCountry
        )
    }
}

extension MovieDetailResponseDTO.ProductionCountryDTO {
    func toDomain() -> MovieDetail.ProductionCountry {
        MovieDetail.ProductionCountry(
            iso3166_1: self.iso3166_1,
            name: self.name
        )
    }
}

extension MovieDetailResponseDTO.SpokenLanguageDTO {
    func toDomain() -> MovieDetail.SpokenLanguage {
        MovieDetail.SpokenLanguage(
            englishName: self.englishName,
            iso639_1: self.iso639_1,
            name: self.name
        )
    }
}
