//
//  NetworkManager.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// Network response details
enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated."
    case badRequest = "Bad request."
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

// Network response result.
enum Result<String> {
    case success
    case failure(String)
}

// Used to make network requests. Should define custom request to various APIs via extensions.
struct NetworkManager {
    let router: Router

    init(with router: Router) {
        self.router = router
    }

    /// Determines the result of the given url response based on its status code.
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
