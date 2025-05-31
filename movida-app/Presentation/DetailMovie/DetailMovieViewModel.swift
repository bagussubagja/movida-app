//
//  DetailMovieViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

enum DetailViewState {
    case idle
    case loading
    case success
    case failure(Error)
}

enum MovieVideoViewState {
    case idle
    case loading
    case success
    case failure(Error)
}

enum SimilarMovieViewState {
    case idle
    case loading
    case success
    case failure(Error)
}

class DetailMovieViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var movieVideos: [MovieVideo] = []
    @Published var similarMovies: [SimilarMovie] = []
    @Published var detailState: DetailViewState = .idle
    @Published var videoState: MovieVideoViewState = .idle
    @Published var similarMovieState: SimilarMovieViewState = .idle
    
    private let detailUseCase: GetDetailMovieUseCase
    private let videoUseCase: GetMovieVideoUseCase
    private let similarVideoUseCase: GetSimilarMovieUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        detailUseCase: GetDetailMovieUseCase = ServiceLocator.shared.getDetailMovieUseCase,
        videoUseCase: GetMovieVideoUseCase = ServiceLocator.shared.getMovieVideoUseCase,
        similarUseCase: GetSimilarMovieUseCase = ServiceLocator.shared.getSimilarMovieUseCase
    ) {
        self.detailUseCase = detailUseCase
        self.videoUseCase = videoUseCase
        self.similarVideoUseCase = similarUseCase
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
    
    func fetchMovieData(id: String) {
        fetchMovieDetail(id: id)
        fetchMovieVideos(id: id)
        fetchSimilarMovie(id: id)
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
    
    var similarEror: Error? {
        if case .failure(let error) = similarMovieState { return error }
        return nil
    }
}
