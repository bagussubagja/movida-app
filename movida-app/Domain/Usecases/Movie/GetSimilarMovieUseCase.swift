//
//  GetSimilarMovieUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetSimilarMovieUseCase {
    func execute (id: String) -> AnyPublisher<[SimilarMovie], Error>
}

class GetSimilarMoviesInteractor: GetSimilarMovieUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute(id: String) -> AnyPublisher<[SimilarMovie], Error> {
        repository.fetchSimilarMovieVideo(id: id)
    }
}
