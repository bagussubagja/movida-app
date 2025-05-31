//
//  ServiceLocator.swift
//  movida-app
//
//  Created by Bagus Subagja on 25/05/25.
//

import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    let movieService: MovieService
    let movieRepository: MovieRepository
    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getDetailMovieUseCase: GetDetailMovieUseCase

    private init() {
        self.movieService = MovieServiceImpl()
        self.movieRepository = MovieRepositoryImpl(service: movieService)
        self.getTrendingMoviesUseCase = GetTrendingMoviesInteractor(repository: movieRepository)
        self.getDetailMovieUseCase = GetDetailMovieInteractor(repository: movieRepository)
    }
}

