//
//  HomeViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var nowPlaying: [NowPlayingMovie] = []
    @Published var airedTVShows: [TVShow] = []
    @Published var searchResults: [MovieSearch] = []
    
    @Published var movieState: ViewState = .idle
    @Published var tvState: ViewState = .idle
    @Published var isSearching: Bool = false

    private let movieUseCase: GetNowPlayingUseCase
    private let tvUseCase: GetAiredTvShowUseCase
    private let searchUseCase: GetMoviesByQueryUseCase

    private var cancellables = Set<AnyCancellable>()

    init(
        movieUseCase: GetNowPlayingUseCase = ServiceLocator.shared.getNowPlayingMoviesUseCase,
        tvUseCase: GetAiredTvShowUseCase = ServiceLocator.shared.getAiredTvShow,
        searchUseCase: GetMoviesByQueryUseCase = ServiceLocator.shared.getMovieByQueryUseCase
    ) {
        self.movieUseCase = movieUseCase
        self.tvUseCase = tvUseCase
        self.searchUseCase = searchUseCase
    }
    
    func refresh(for tab: TabCategory) async {
            switch tab {
            case .movies:
                self.movieState = .idle
                fetchNowPlayingMovies()
            case .tvSeries:
                self.tvState = .idle
                fetchAiredTvShows()
            }
        }

    func fetchNowPlayingMovies() {
        movieState = .loading
        movieUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.movieState = .failure(error)
                }
            } receiveValue: { [weak self] movies in
                self?.nowPlaying = movies
                self?.movieState = .success
            }
            .store(in: &cancellables)
    }

    func fetchAiredTvShows() {
        tvState = .loading
        tvUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.tvState = .failure(error)
                }
            } receiveValue: { [weak self] tvShows in
                self?.airedTVShows = tvShows
                self?.tvState = .success
            }
            .store(in: &cancellables)
    }

    func searchMovies(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        searchUseCase.execute(query: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSearching = false
                if case .failure(_) = completion {
                    self?.searchResults = []
                }
            } receiveValue: { [weak self] movies in
                self?.searchResults = movies
            }
            .store(in: &cancellables)
    }
}
