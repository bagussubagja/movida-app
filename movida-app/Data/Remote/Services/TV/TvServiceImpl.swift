//
//  TvServiceImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//

import Combine
import Foundation
import Alamofire

class TvServiceImpl: TvService {

    func getAiredTvShow() -> AnyPublisher<PopularTVShowResponseDTO, any Error> {
        let components = URLComponents(string: "\(Constant.baseURL)/tv/airing_today")!

        guard let urlString = components.url?.absoluteString else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constant.bearerToken)",
            "accept": "application/json"
        ]

        return APIClient.shared
            .request(PopularTVShowResponseDTO.self, from: urlString, headers: headers)
            .eraseToAnyPublisher()
    }
}
    
