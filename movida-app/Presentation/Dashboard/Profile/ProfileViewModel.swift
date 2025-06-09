//
//  ProfileViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var favoriteMovies: [FavoriteMovie] = []
    @Published var watchlistMovies: [WatchlistMovie] = []
    @Published var state: ViewState = .idle
    
    private let getCurrentUserUseCase: GetCurrentUserUseCase
    private let signOutUseCase: SignOutUseCase
    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    private let getWatchlistMoviesUseCase: GetWatchlistMoviesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteMovieUseCase
    private let removeWatchlistUseCase: RemoveMovieFromWatchlistUseCase

    private var cancellables = Set<AnyCancellable>()

    init() {
        let locator = ServiceLocator.shared
        self.getCurrentUserUseCase = locator.getCurrentUserUseCase
        self.signOutUseCase = locator.signOutUseCase
        self.getFavoriteMoviesUseCase = locator.getFavorites
        self.getWatchlistMoviesUseCase = locator.getWatchlist
        self.removeFavoriteUseCase = locator.removeFavorite
        self.removeWatchlistUseCase = locator.removeWatchlist
        
        self.user = getCurrentUserUseCase.execute()
    }
    
    func onAppear() {
        guard state == .idle else { return }
        fetchAllData()
    }
    
    private func fetchAllData() {
        self.state = .loading
        
        let favoritesPublisher = createFuture { try await self.getFavoriteMoviesUseCase.execute() }
        let watchlistPublisher = createFuture { try await self.getWatchlistMoviesUseCase.execute() }
        
        Publishers.Zip(favoritesPublisher, watchlistPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error)
                }
            }, receiveValue: { [weak self] (favorites, watchlist) in
                guard let self = self else { return }
                
                self.favoriteMovies = favorites
                self.watchlistMovies = watchlist
                self.state = .success
            })
            .store(in: &cancellables)
    }
    
    func signOut() async throws {
        try await signOutUseCase.execute()
    }
    
    private func createFuture<T>(for asyncOperation: @escaping () async throws -> T) -> Future<T, Error> {
        return Future { promise in
            Task {
                do {
                    let result = try await asyncOperation()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
