//
//  Router.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import Combine

private typealias URLSessionOutput = URLSession.DataTaskPublisher.Output

protocol NetworkRouter {
    var session: URLSessionProtocol { get }
}

extension NetworkRouter {
    func request<T: Decodable>(_ route: EndPoint) -> AnyPublisher<T, NetworkError> {
        let request = buildRequest(from: route)

        return session.dataTaskPublisher(for: request)
            .mapDataHandlingResponse()
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                let networkError: NetworkError
                if let netError = error as? NetworkError {
                    networkError = netError
                } else if error is DecodingError {
                    networkError = .unableToDecode
                } else {
                    networkError = .failed
                }
                return networkError
            }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    // Request builder
    private func buildRequest(from route: EndPoint) -> URLRequest {
        var request = URLRequest(url: route.url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

private extension Publisher where Output == URLSessionOutput {
    func mapDataHandlingResponse() -> AnyPublisher<Data, Error> {
        return tryMap {
                try self.handleNetworkResponse(sessionOutput: $0)
                return $0.data
            }
            .eraseToAnyPublisher()
    }

    private func handleNetworkResponse(sessionOutput: URLSessionOutput) throws {
        guard let response = sessionOutput.response as? HTTPURLResponse else {
            throw NetworkError.failed
        }
        switch response.statusCode {
        case 200...299: return
        case 401...500: throw NetworkError.authenticationError
        case 501...599: throw NetworkError.badRequest
        case 600: throw NetworkError.outdated
        default: throw NetworkError.failed
        }
    }
}
