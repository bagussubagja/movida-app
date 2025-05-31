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

    private let useCase: GetTrendingMoviesUseCase
    private var cancellables = Set<AnyCancellable>()

    init(useCase: GetTrendingMoviesUseCase = ServiceLocator.shared.getTrendingMoviesUseCase) {
        self.useCase = useCase
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
}
