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

}
