//
//  ApiRouter.swift
//  SearchOverflow
//
//  Created by Seth Folley on 11/18/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

struct ApiRouter: NetworkRouter {
    let session: URLSessionProtocol

    init(sessionConfig: URLSessionConfiguration) {
        session = URLSession(configuration: sessionConfig)
    }
}
