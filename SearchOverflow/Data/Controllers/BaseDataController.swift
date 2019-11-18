//
//  BaseDataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol BaseDataController {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError>
}

extension BaseDataController {
    /// Determines the result of the given url response based on its status code.
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 401...500: return .failure(.authenticationError)
        case 501...599: return .failure(.badRequest)
        case 600: return .failure(.outdated)
        default: return .failure(.failed)
        }
    }
}
