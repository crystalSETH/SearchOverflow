//
//  Router.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

class Router<EP: EndPoint>: NetworkRouter {
    private var task: URLSessionTask?

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared

        let request = buildRequest(from: route)
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, response, error)
        })


        self.task?.resume()
    }

    func cancel() {
        self.task?.cancel()
    }

    // Request builder
    private func buildRequest(from route: EndPoint) -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
