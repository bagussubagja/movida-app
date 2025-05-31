//
//  MovieServiceImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine
import Foundation
import Alamofire

class MovieServiceImpl: MovieService {
    
    
    func getMoviesByQuery(query: String) -> AnyPublisher<MovieSearchResponseDTO, any Error> {
        let components = URLComponents(string: "\(Constant.baseURL)/search/movie?query=\(query)")!

        guard let urlString = components.url?.absoluteString else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]

        return APIClient.shared
            .request(MovieSearchResponseDTO.self, from: urlString, headers: headers)
            .eraseToAnyPublisher()
    }
    
    func getNowPlayingMovies() -> AnyPublisher<NowPlayingMovieResponseDTO, Error> {
            let components = URLComponents(string: "\(Constant.baseURL)/movie/now_playing")!

            guard let urlString = components.url?.absoluteString else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }

            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(Constant.bearerToken)",
                "accept": "application/json"
            ]

            return APIClient.shared
                .request(NowPlayingMovieResponseDTO.self, from: urlString, headers: headers)
                .eraseToAnyPublisher()
        }
    
    func getSimilarMovie(id: String) -> AnyPublisher<SimilarMovieResponseDTO, any Error> {
        guard var components = URLComponents(string: "\(Constant.baseURL)/movie/\(id)/similar") else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL structure"]))
                .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL with query items"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]
        
        return APIClient.shared
            .request(SimilarMovieResponseDTO.self, from: url.absoluteString, headers: headers)
            .eraseToAnyPublisher()
    }
    
    func getMovieVideo(id: String) -> AnyPublisher<MovieVideoResponseDTO, any Error> { // Changed return type
        guard var components = URLComponents(string: "\(Constant.baseURL)/movie/\(id)/videos") else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL structure"]))
                .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL with query items"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]
        
        return APIClient.shared
            .request(MovieVideoResponseDTO.self, from: url.absoluteString, headers: headers)
            .eraseToAnyPublisher()
    }
    
    func getDetailMovie(id: String) -> AnyPublisher<MovieDetailResponseDTO, Error> {
        guard var components = URLComponents(string: "https://api.themoviedb.org/3/movie/\(id)") else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Invalid base URL structure"]))
                .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = components.url else {
            return Fail(error: URLError(.badURL, userInfo: [NSLocalizedDescriptionKey: "Failed to construct URL with query items"]))
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]
        
        return APIClient.shared
            .request(MovieDetailResponseDTO.self, from: url.absoluteString, headers: headers)
            .eraseToAnyPublisher()
    }

    func getTrendingMovies() -> AnyPublisher<[MovieResponseDTO], Error> {
        let components = URLComponents(string: "\(Constant.baseURL)/trending/movie/day")!
        
        guard let urlString = components.url?.absoluteString else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]
        
        return APIClient.shared
            .request(MovieListResponseDTO.self, from: urlString, headers: headers)
            .map(\.results)
            .eraseToAnyPublisher()
    }

    func getUpcomingMovies() -> AnyPublisher<[MovieResponseDTO], Error> {
        var components = URLComponents(string: "\(Constant.baseURL)/movie/upcoming")!
        components.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let urlString = components.url?.absoluteString else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]

        return APIClient.shared
            .request(MovieListResponseDTO.self, from: urlString, headers: headers)
            .map(\.results)
            .eraseToAnyPublisher()
    }
}
