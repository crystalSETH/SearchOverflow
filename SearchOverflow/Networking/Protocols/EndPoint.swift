//
//  EndPoint.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

/// Defines an endpoint to be used by Routers
protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
}

extension EndPoint {
    var url: URL {
        return URL(string: baseURL.absoluteString + path)!
    }
}
