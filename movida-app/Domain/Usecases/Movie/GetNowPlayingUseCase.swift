//
//  GetNowPlayingUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetNowPlayingUseCase {
    func execute () -> AnyPublisher<[NowPlayingMovie], Error>
}

class GetNowPlayingMoviesInteractor: GetNowPlayingUseCase {
    private let repository: MovieRepository

    init(repository: MovieRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[NowPlayingMovie], Error> {
        repository.fetchNowPlayingMovies()
    }
}
