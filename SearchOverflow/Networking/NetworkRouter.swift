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

    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {

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
        var request = URLRequest(url: route.baseURL,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
