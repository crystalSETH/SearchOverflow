//
//  StackOverflow+NetworkManager.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// MARK: Search
typealias SearchCompletion = (_ results: [Question], _ error: String?) -> Void
extension NetworkManager {
    /// Searches for the given text in the title of StackOverflow questions.
    func search(for text: String, completion: @escaping SearchCompletion) {

        // Request data
        router.request(StackOverflow.search(for: text)) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                completion([], error.debugDescription)
                return
            }

            // Handle the network response, parse data, and call completion
            switch self.handleNetworkResponse(urlResponse) {
            case .success:
                guard let responseData = data else {
                    completion([], NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    // Try to parse the response data
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)

                    // Completes with the question items, no error
                    completion(apiReponse.items, nil)
                } catch {
                    // Complete with a parsing error
                    completion([], NetworkResponse.unableToDecode.rawValue)
                }

            case .failure(let networkFailureError):
                // Complete with a network error
                completion([], networkFailureError)
            }
        }
    }
}
