//
//  BaseDataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol BaseDataController {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>
}

extension BaseDataController {
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
