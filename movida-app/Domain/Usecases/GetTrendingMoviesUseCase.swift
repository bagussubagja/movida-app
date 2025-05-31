//
//  GetTrendingMoviesUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetTrendingMoviesUseCase {
    func execute() -> AnyPublisher<[Movie], Error>
}

class GetTrendingMoviesInteractor: GetTrendingMoviesUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Movie], Error> {
        repository.fetchTrendingMovies()
    }
}
