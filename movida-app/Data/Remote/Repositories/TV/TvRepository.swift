//
//  TvRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine
import Foundation

protocol TvRepository {
    func fetchAiredTvShow() -> AnyPublisher<[TVShow], Error>
}
