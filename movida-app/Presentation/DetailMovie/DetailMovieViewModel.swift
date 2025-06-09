//
//  DetailMovieViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

enum DetailViewState: Equatable {
    case idle, loading, success, failure(Error)
    static func == (lhs: DetailViewState, rhs: DetailViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success): return true
        case (.failure(let e1), .failure(let e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}
enum MovieVideoViewState: Equatable {
    case idle, loading, success, failure(Error)
    static func == (lhs: MovieVideoViewState, rhs: MovieVideoViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success): return true
        case (.failure(let e1), .failure(let e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}
enum SimilarMovieViewState: Equatable {
    case idle, loading, success, failure(Error)
    static func == (lhs: SimilarMovieViewState, rhs: SimilarMovieViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success): return true
        case (.failure(let e1), .failure(let e2)): return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}


@MainActor
class DetailMovieViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var movieVideos: [MovieVideo] = []
    @Published var similarMovies: [SimilarMovie] = []
    
    @Published var detailState: DetailViewState = .idle
    @Published var videoState: MovieVideoViewState = .idle
    @Published var similarMovieState: SimilarMovieViewState = .idle
    
    @Published var isFavorite: Bool = false
    @Published var isInWatchlist: Bool = false

    private let detailUseCase: GetDetailMovieUseCase
    private let videoUseCase: GetMovieVideoUseCase
    private let similarVideoUseCase: GetSimilarMovieUseCase
    private let addFavoriteUseCase: AddFavoriteMovieUseCase
    private let removeFavoriteUseCase: RemoveFavoriteMovieUseCase
    private let addWatchlistUseCase: AddMovieToWatchlistUseCase
    private let checkIsFavoriteUseCase: CheckIsFavoriteUseCase
    private let checkIsInWatchlistUseCase: CheckIsInWatchlistUseCase

    private var cancellables = Set<AnyCancellable>()
    
    init(
        detailUseCase: GetDetailMovieUseCase = ServiceLocator.shared.getDetailMovieUseCase,
        videoUseCase: GetMovieVideoUseCase = ServiceLocator.shared.getMovieVideoUseCase,
        similarUseCase: GetSimilarMovieUseCase = ServiceLocator.shared.getSimilarMovieUseCase,
        addFavoriteUseCase: AddFavoriteMovieUseCase = ServiceLocator.shared.addFavorite,
        removeFavoriteUseCase: RemoveFavoriteMovieUseCase = ServiceLocator.shared.removeFavorite,
        addWatchlistUseCase: AddMovieToWatchlistUseCase = ServiceLocator.shared.addWatchlist,
        checkIsFavoriteUseCase: CheckIsFavoriteUseCase = ServiceLocator.shared.checkIsFavorite,
        checkIsInWatchlistUseCase: CheckIsInWatchlistUseCase = ServiceLocator.shared.checkIsInWatchlist
    ) {
        self.detailUseCase = detailUseCase
        self.videoUseCase = videoUseCase
        self.similarVideoUseCase = similarUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.addWatchlistUseCase = addWatchlistUseCase
        self.checkIsFavoriteUseCase = checkIsFavoriteUseCase
        self.checkIsInWatchlistUseCase = checkIsInWatchlistUseCase
    }
    
    func onAppear(movieId: String) {
        checkStatus(for: movieId)
        
        if movieDetail == nil {
            fetchMovieData(id: movieId)
        }
    }
    
    
    func fetchMovieData(id: String) {
        if movieDetail == nil {
            fetchMovieDetail(id: id)
            fetchMovieVideos(id: id)
            fetchSimilarMovie(id: id)
            checkStatus(for: id)
        }
    }
    
    func toggleFavorite() {
          guard let movie = movieDetail else { return }
          
        let favoriteMovie = FavoriteMovie(id: String(movie.id), title: movie.title, imageUrl: movie.fullPosterURL?.absoluteString ?? "", movieId: String(movie.id))
          let newFavoriteStatus = !isFavorite
          self.isFavorite = newFavoriteStatus

          Task {
              do {
                  if newFavoriteStatus {
                      try await addFavoriteUseCase.execute(movie: favoriteMovie)
                  } else {
                      try await removeFavoriteUseCase.execute(id: String(movie.id))
                  }
              } catch {
                  self.isFavorite = !newFavoriteStatus
              }
          }
      }
    
    func addToWatchlist() {
        guard let movie = movieDetail, !isInWatchlist else { return }
        
        let watchlistMovie = WatchlistMovie(id: String(movie.id), title: movie.title, imageUrl: movie.fullPosterURL?.absoluteString ?? "")
        
        Task {
            do {
                try await addWatchlistUseCase.execute(movie: watchlistMovie)
                self.isInWatchlist = true
            } catch {
                print("Gagal menambahkan ke watchlist: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func checkStatus(for movieId: String) {
        Task {
            async let favoriteStatus = checkIsFavoriteUseCase.execute(id: movieId)
            async let watchlistStatus = checkIsInWatchlistUseCase.execute(id: movieId)
            
            let (isFav, inWatch) = await (favoriteStatus, watchlistStatus)
            
            self.isFavorite = isFav
            self.isInWatchlist = inWatch
        }
    }

    func fetchMovieDetail(id: String) {
        detailState = .loading
        detailUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.detailState = .failure(error)
                }
            } receiveValue: { [weak self] detail in
                self?.movieDetail = detail
                self?.detailState = .success
            }
            .store(in: &cancellables)
    }
    
    func fetchMovieVideos(id: String) {
        videoState = .loading
        videoUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.videoState = .failure(error)
                }
            } receiveValue: { [weak self] videos in
                self?.movieVideos = videos
                self?.videoState = .success
            }
            .store(in: &cancellables)
    }
    
    func fetchSimilarMovie(id: String) {
        similarMovieState = .loading
        
        similarVideoUseCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.similarMovieState = .failure(error)
                }
            } receiveValue: { [weak self] similar in
                self?.similarMovies = similar
                self?.similarMovieState = .success
            }
            .store(in: &cancellables)
    }
    
    var isDetailLoading: Bool {
        if case .loading = detailState { return true }
        return false
    }
    
    var isVideoLoading: Bool {
        if case .loading = videoState { return true }
        return false
    }
    
    var isSimilarLoading: Bool {
        if case .loading = similarMovieState { return true }
        return false
    }
    
    var isAnyLoading: Bool {
        isDetailLoading || isVideoLoading || isSimilarLoading
    }
    
    var detailError: Error? {
        if case .failure(let error) = detailState { return error }
        return nil
    }
    
    var videoError: Error? {
        if case .failure(let error) = videoState { return error }
        return nil
    }
    
    var similarError: Error? {
        if case .failure(let error) = similarMovieState { return error }
        return nil
    }
}
