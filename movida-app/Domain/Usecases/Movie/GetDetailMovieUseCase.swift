//
//  GetDetailMovieUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetDetailMovieUseCase {
    func execute (id: String) -> AnyPublisher<MovieDetail, Error>
}

class GetDetailMovieInteractor : GetDetailMovieUseCase {
    private let repository : MovieRepository
    
    init (repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<MovieDetail, Error> {
        repository.fetchDetailMovie(id: id)
    }
}
