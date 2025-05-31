//
//  TvRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Foundation
import Combine

class TvRepositoryImpl: TvRepository {
 
    private let service: TvService
    
    init(service: TvService) {
        self.service = service
    }
    
    func fetchAiredTvShow() -> AnyPublisher<[TVShow], any Error> {
        service.getAiredTvShow()
            .map { response in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
