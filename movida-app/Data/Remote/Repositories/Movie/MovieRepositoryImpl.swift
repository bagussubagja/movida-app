//
//  MovieRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

class MovieRepositoryImpl: MovieRepository {
    
    private let service: MovieService

    init(service: MovieService) {
        self.service = service
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

}
