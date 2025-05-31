//
//  TvService.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine

protocol TvService {
    func getAiredTvShow() -> AnyPublisher<PopularTVShowResponseDTO, Error>
}
