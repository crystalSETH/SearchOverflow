//
//  NetworkRouter.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

public typealias RouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void

protocol Router: class {
    func request(_ route: EndPoint, completion: @escaping RouterCompletion)
    func cancel()
}
