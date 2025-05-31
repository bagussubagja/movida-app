//
//  MovieService.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol MovieService {
    func getTrendingMovies() -> AnyPublisher<[MovieResponseDTO], Error>
    func getUpcomingMovies() -> AnyPublisher<[MovieResponseDTO], Error>
    func getDetailMovie(id: String) -> AnyPublisher<MovieDetailResponseDTO, Error>
    func getMovieVideo(id: String) -> AnyPublisher<MovieVideoResponseDTO, Error>
    func getSimilarMovie(id: String) -> AnyPublisher<SimilarMovieResponseDTO, Error>
    func getNowPlayingMovies() -> AnyPublisher<NowPlayingMovieResponseDTO, Error>
    func getMoviesByQuery(query: String) -> AnyPublisher<MovieSearchResponseDTO, Error>
}
