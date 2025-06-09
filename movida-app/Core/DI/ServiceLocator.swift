//
//  ServiceLocator.swift
//  movida-app
//
//  Created by Bagus Subagja on 25/05/25.
//

import Foundation

class ServiceLocator {
    static let shared = ServiceLocator()
    
    // Service
    let movieService: MovieService
    let tvService: TvService
    let favoriteService: FavoriteService
    let watchlistService: WatchlistService
    let authService: AuthService
    
    // Repository
    let movieRepository: MovieRepository
    let tvRepository: TvRepository
    let favoriteRepository: FavoriteMovieRepository
    let watchlistRepository: WatchlistMovieRepository
    let authRepository: AuthRepository
    
    // Usecase
    let getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    let getDetailMovieUseCase: GetDetailMovieUseCase
    let getMovieVideoUseCase: GetMovieVideoUseCase
    let getSimilarMovieUseCase: GetSimilarMovieUseCase
    let getNowPlayingMoviesUseCase: GetNowPlayingUseCase
    let getMovieByQueryUseCase: GetMoviesByQueryUseCase
    let getAiredTvShow: GetAiredTvShowUseCase
    let addFavorite: AddFavoriteMovieUseCase
    let getFavorites: GetFavoriteMoviesUseCase
    let removeFavorite: RemoveFavoriteMovieUseCase
    let addWatchlist: AddMovieToWatchlistUseCase
    let getWatchlist: GetWatchlistMoviesUseCase
    let removeWatchlist: RemoveMovieFromWatchlistUseCase
    let checkIsFavorite: CheckIsFavoriteUseCase
    let checkIsInWatchlist: CheckIsInWatchlistUseCase
    let signInUseCase: SignInUseCase
    let signUpUseCase: SignUpUseCase
    let getCurrentUserUseCase: GetCurrentUserUseCase
    let signOutUseCase: SignOutUseCase

    private init() {
        self.movieService = MovieServiceImpl()
        self.tvService = TvServiceImpl()
        self.authService = AuthServiceImpl()
        self.favoriteService = FavoriteServiceImpl()
        self.watchlistService = WatchlistServiceImpl()
        self.movieRepository = MovieRepositoryImpl(service: movieService)
        self.tvRepository = TvRepositoryImpl(service: tvService)
        self.authRepository = AuthRepositoryImpl(authService: authService)
        self.favoriteRepository = FavoriteMovieRepositoryImpl(firestoreService: favoriteService)
        self.watchlistRepository = WatchlistMovieRepositoryImpl(realmService: watchlistService)
        self.getTrendingMoviesUseCase = GetTrendingMoviesInteractor(repository: movieRepository)
        self.getDetailMovieUseCase = GetDetailMovieInteractor(repository: movieRepository)
        self.getMovieVideoUseCase = GetMovieVideoInteractor(repository: movieRepository)
        self.getSimilarMovieUseCase = GetSimilarMoviesInteractor(repository: movieRepository)
        self.getNowPlayingMoviesUseCase = GetNowPlayingMoviesInteractor(repository: movieRepository)
        self.getMovieByQueryUseCase = GetMoviesByQueryInteractor(repository: movieRepository)
        self.getAiredTvShow = GetAiredTvShowInteractor(repository: tvRepository)
        self.addFavorite = AddFavoriteMovieUseCase(repository: favoriteRepository)
        self.getFavorites = GetFavoriteMoviesUseCase(repository: favoriteRepository)
        self.removeFavorite = RemoveFavoriteMovieUseCase(repository: favoriteRepository)
        self.addWatchlist = AddMovieToWatchlistUseCase(repository: watchlistRepository)
        self.getWatchlist = GetWatchlistMoviesUseCase(repository: watchlistRepository)
        self.removeWatchlist = RemoveMovieFromWatchlistUseCase(repository: watchlistRepository)
        self.checkIsFavorite = CheckIsFavoriteUseCase(repository: favoriteRepository)
        self.checkIsInWatchlist = CheckIsInWatchlistUseCase(repository: watchlistRepository)
        self.signInUseCase = SignInUseCase(repository: authRepository)
        self.signUpUseCase = SignUpUseCase(repository: authRepository)
        self.getCurrentUserUseCase = GetCurrentUserUseCase(repository: authRepository)
        self.signOutUseCase = SignOutUseCase(repository: authRepository)
    }
}

