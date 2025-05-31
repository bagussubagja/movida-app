//
//  DetailMovieViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

class DetailMovieViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var state: ViewState = .idle
    private let useCase: GetDetailMovieUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: GetDetailMovieUseCase = ServiceLocator.shared.getDetailMovieUseCase) {
        self.useCase = useCase
    }
    
    func fetchMovieDetail(id: String) {
        state = .loading
        useCase.execute(id: id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error)
                }
            } receiveValue: { [weak self] detail in
                self?.movieDetail = detail
                self?.state = .success
            }
            .store(in: &cancellables)
    }
}
