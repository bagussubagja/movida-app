//
//  MovieRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine
import Foundation

protocol MovieRepository {
    func fetchTrendingMovies() -> AnyPublisher<[Movie], Error>
    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error>
    func fetchDetailMovie(id: String) -> AnyPublisher<MovieDetail, Error>
    func fetchMovieVideo(id: String) -> AnyPublisher<[MovieVideo], Error>
    func fetchSimilarMovieVideo(id: String) -> AnyPublisher<[SimilarMovie], Error>
    func fetchNowPlayingMovies() -> AnyPublisher<[NowPlayingMovie], Error>
    func fetchMovieByQuery(query: String) -> AnyPublisher<[MovieSearch], Error>
}
