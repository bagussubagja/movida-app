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
    let tvService: TvService
    let movieRepository: MovieRepository
    let tvRepository: TvRepository
    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getDetailMovieUseCase: GetDetailMovieUseCase
    let getMovieVideoUseCase: GetMovieVideoUseCase
    let getSimilarMovieUseCase: GetSimilarMovieUseCase
    let getNowPlayingMoviesUseCase: GetNowPlayingUseCase
    let getMovieByQueryUseCase: GetMoviesByQueryUseCase
    let getAiredTvShow: GetAiredTvShowUseCase

    private init() {
        self.movieService = MovieServiceImpl()
        self.tvService = TvServiceImpl()
        self.movieRepository = MovieRepositoryImpl(service: movieService)
        self.tvRepository = TvRepositoryImpl(service: tvService)
        self.getTrendingMoviesUseCase = GetTrendingMoviesInteractor(repository: movieRepository)
        self.getDetailMovieUseCase = GetDetailMovieInteractor(repository: movieRepository)
        self.getMovieVideoUseCase = GetMovieVideoInteractor(repository: movieRepository)
        self.getSimilarMovieUseCase = GetSimilarMoviesInteractor(repository: movieRepository)
        self.getNowPlayingMoviesUseCase = GetNowPlayingMoviesInteractor(repository: movieRepository)
        self.getMovieByQueryUseCase = GetMoviesByQueryInteractor(repository: movieRepository)
        self.getAiredTvShow = GetAiredTvShowInteractor(repository: tvRepository)
    }
}

