//
//  GetMoviesByQueryUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetMoviesByQueryUseCase {
    func execute (query: String) -> AnyPublisher<[MovieSearch], Error>
}

class GetMoviesByQueryInteractor: GetMoviesByQueryUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(query: String) -> AnyPublisher<[MovieSearch], Error> {
        repository.fetchMovieByQuery(query: query)
    }
}
