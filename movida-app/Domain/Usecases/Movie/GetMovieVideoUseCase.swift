//
//  GetMovieVideoUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol GetMovieVideoUseCase {
    func execute (id: String) -> AnyPublisher<[MovieVideo], Error>
}

class GetMovieVideoInteractor : GetMovieVideoUseCase {
    private let repository : MovieRepository
    
    init (repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(id: String) -> AnyPublisher<[MovieVideo], Error> {
        repository.fetchMovieVideo(id: id)
    }
}
