//
//  APIClient.swift
//  movida-app
//
//  Created by Bagus Subagja on 25/05/25.
//


import Foundation
import Combine
import Alamofire

class APIClient {
    static let shared = APIClient()

    private init() {}

    func request<T: Decodable>(
        _ type: T.Type,
        from url: String,
        method: HTTPMethod = .get,
        parameters: [String: Any]? = nil,
        headers: HTTPHeaders? = nil
    ) -> AnyPublisher<T, Error> {
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        
        print("\nAPI REQUEST:")
        print("URL: \(url)")
        print("Method: \(method.rawValue)")
        if let params = parameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted]),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Parameters:\n\(jsonString)")
            } else {
                print("Parameters: \(params)")
            }
        } else {
            print("Parameters: nil")
        }
        
        if let headers = headers {
            print("Headers: \(headers.dictionary)")
        } else {
            print("Headers: nil")
        }
        
        return Future { promise in
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("\n API Response Success:")
                            print("URL: \(url)")
                            print("Response Data:\n\(jsonString)")
                        } else {
                            print("\n API Response Success: (binary data)")
                            print("URL: \(url)")
                        }
                        
                        do {
                            let decoded = try JSONDecoder().decode(T.self, from: data)
                            promise(.success(decoded))
                        } catch {
                            print("Decoding error: \(error.localizedDescription)")
                            promise(.failure(error))
                        }
                        
                    case .failure(let error):
                        print("\nAPI Response Failure:")
                        print("URL: \(url)")
                        print("Error: \(error.localizedDescription)")
                        if let data = response.data,
                           let errorString = String(data: data, encoding: .utf8) {
                            print("Error Data:\n\(errorString)")
                        }
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
