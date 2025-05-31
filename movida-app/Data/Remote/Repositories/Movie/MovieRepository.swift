//
//  MovieRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol MovieRepository {
    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error>
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error>
    func fetchDetailMovie(id: String) -> AnyPublisher<MovieDetail, Error>
}
