//
//  Router.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

class NetworkRouter: Router {
    var session: URLSessionProtocol = URLSession.shared
    var task: URLSessionTask?

    /// Uses the previously defined session and task to complete the request given a specific Endpoint.
    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {

        let request = buildRequest(from: route)
        task = session.dataTask(with: request, completionHandler: { data, response, error in
            completion(data, response, error)
        })


        self.task?.resume()
    }

    /// Cancles the session task, if there is one.
    func cancel() {
        self.task?.cancel()
    }

    // Request builder
    private func buildRequest(from route: EndPoint) -> URLRequest {
        var request = URLRequest(url: route.baseURL,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
