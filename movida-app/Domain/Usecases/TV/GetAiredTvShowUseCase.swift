//
//  GetAiredTvShowUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetAiredTvShowUseCase {
    func execute () -> AnyPublisher<[TVShow], Error>
}

class GetAiredTvShowInteractor: GetAiredTvShowUseCase {
    private let repository: TvRepository

    init(repository: TvRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[TVShow], Error> {
        repository.fetchAiredTvShow()
    }
}
