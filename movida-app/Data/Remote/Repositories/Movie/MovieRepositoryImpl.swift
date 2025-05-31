//
//  MovieRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine
import Foundation

class MovieRepositoryImpl: MovieRepository {
    
    private let service: MovieService
    
    init(service: MovieService) {
        self.service = service
    }
    
    func fetchMovieByQuery(query: String) -> AnyPublisher<[MovieSearch], any Error> {
        service.getMoviesByQuery(query: query)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchNowPlayingMovies() -> AnyPublisher<[NowPlayingMovie], Error> {
            service.getNowPlayingMovies()
                .map { responseDTO in
                    responseDTO.toDomain()
                }
                .eraseToAnyPublisher()
        }
    
    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error> {
        service.getTrendingMovies()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error> {
        service.getUpcomingMovies()
            .map { $0.map { $0.toDomain() } }
            .eraseToAnyPublisher()
    }
    
    func fetchDetailMovie(id: String) -> AnyPublisher<MovieDetail, Error> {
        service.getDetailMovie(id: id)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchMovieVideo(id: String) -> AnyPublisher<[MovieVideo], Error> {
        service.getMovieVideo(id: id)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
    
    func fetchSimilarMovieVideo(id: String) -> AnyPublisher<[SimilarMovie], any Error> {
        service.getSimilarMovie(id: id)
            .map { $0.toDomain() }
            .eraseToAnyPublisher()
    }
}
