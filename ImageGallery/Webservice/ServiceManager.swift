//
//  ServiceManager.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import Combine

protocol APIService {
    var cancellables: Set<AnyCancellable> { get set }
    func requestCombine<T>(with urlRequest: URLRequest) -> AnyPublisher<T, NetworkingError> where T : Decodable
}


struct ServiceManager<T>: APIService {
    var cancellables: Set<AnyCancellable>
    
    init() {
        cancellables = Set<AnyCancellable>()
    }

    func requestCombine<T>(with urlRequest: URLRequest) -> AnyPublisher<T, NetworkingError> where T : Decodable {
        
        let decoder = JSONDecoder()
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in  .unknown }
            .flatMap { data, response -> AnyPublisher<T, NetworkingError> in
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 422 || response.statusCode == 400 || response.statusCode == 500 {
                        
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError {_ in .unableToParseResponse}
                            .eraseToAnyPublisher()
                        
                    } else if (200...299).contains(response.statusCode) {
                        return Just(data)
                            .decode(type: T.self, decoder: decoder)
                            .mapError { error in
                                print(T.self)
                                print(error)
                                return .unableToParseResponse
                                
                            }
                            .eraseToAnyPublisher()
                    } else {
                        return Fail(error: NetworkingError(httpStatusCode: response.statusCode))
                            .eraseToAnyPublisher()
                    }
                }
                return Fail(error: NetworkingError.unknown)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
