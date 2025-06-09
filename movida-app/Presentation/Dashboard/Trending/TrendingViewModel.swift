//
//  TrendingViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

class TrendingViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var state: ViewState = .idle
    @Published var lastWatchedMovie: WatchlistMovie?

    private let useCase: GetTrendingMoviesUseCase
    private let watchlistUseCase: GetWatchlistMoviesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        useCase: GetTrendingMoviesUseCase = ServiceLocator.shared.getTrendingMoviesUseCase,
           watchlistUseCase: GetWatchlistMoviesUseCase = ServiceLocator.shared.getWatchlist
       ) {
           self.useCase = useCase
           self.watchlistUseCase = watchlistUseCase
       }
    
    func refresh() async {
        onAppear()
    }
    
    func onAppear() {
        fetchLastWatchedMovie()
        if trendingMovies.isEmpty && state == .idle {
            fetchTrendingMovies()
        }
    }

    func fetchTrendingMovies() {
        state = .loading

        useCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.state = .failure(error)
                }
            } receiveValue: { [weak self] movies in
                guard let self = self else { return }
                self.trendingMovies = movies
                self.state = .success
            }
            .store(in: &cancellables)
    }
    
    func fetchLastWatchedMovie() {
            Task {
                do {
                    let watchlist = try await watchlistUseCase.execute()
                    await MainActor.run {
                        self.lastWatchedMovie = watchlist.first
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
}
