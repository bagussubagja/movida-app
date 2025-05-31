//
//  Video.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import Foundation // For URL and Date
import SwiftUI // Not strictly needed for the model itself, but good practice for SwiftUI entities

// MARK: - Video (View Entity)
struct MovieVideo: Identifiable, Hashable {
    let id: String // Using the video ID from the API
    let name: String
    let key: String // The unique identifier for the video on its site (e.g., YouTube video ID)
    let site: String
    let type: String // e.g., "Trailer", "Teaser"
    let isOfficial: Bool
    let publishedDate: Date? // Converted to Date for easier handling
    let videoURL: URL? // A computed property for direct use in WebView or Safari

    // You might also include size and language details if your UI needs them:
    // let size: Int
    // let languageCode: String
    // let countryCode: String

    init(from dto: VideoResultDTO) {
        self.id = dto.id
        self.name = dto.name
        self.key = dto.key
        self.site = dto.site
        self.type = dto.type
        self.isOfficial = dto.official

        // Attempt to parse the date string
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // For the 'Z' and potential milliseconds
        self.publishedDate = dateFormatter.date(from: dto.publishedAt)

        // Construct the video URL based on the site
        if dto.site.lowercased() == "youtube" {
            self.videoURL = URL(string: "https://www.youtube.com/watch?v=\(dto.key)")
        } else {
            // Handle other sites or return nil
            self.videoURL = nil
        }
    }

    // Example: A static property to conform to Identifiable/Hashable for previews
    static var example: MovieVideo {
        MovieVideo(from: VideoResultDTO(
            iso639_1: "en",
            iso3166_1: "US",
            name: "Official Trailer [EN SUB]",
            key: "VvMbyw_vIcA",
            site: "YouTube",
            size: 1080,
            type: "Trailer",
            official: true,
            publishedAt: "2025-05-15T00:00:01.000Z",
            id: "682586bb8529c58a5e6ef36e"
        ))
    }
}

// MARK: - Example Usage / Transformation Logic
extension MovieVideoResponseDTO {
    /// Converts the DTO into a list of view-friendly Video entities.
    var toVideos: [MovieVideo] {
        results.map { MovieVideo(from: $0) }
    }
}

extension MovieVideo {
    var isYouTube: Bool {
        site.lowercased() == "youtube"
    }
    
    var isTrailer: Bool {
        type.lowercased() == "trailer"
    }
    
    var isTeaser: Bool {
        type.lowercased() == "teaser"
    }
    
    var publishedAt: Date {
        publishedDate ?? Date.distantPast
    }
}
