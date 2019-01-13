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
    func search(for text: String, completion: @escaping SearchCompletion) {
        router.request(StackOverflow.search(for: text)) { data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                completion([], error.debugDescription)
                return
            }

            switch self.handleNetworkResponse(urlResponse) {
            case .success:
                guard let responseData = data else {
                    completion([], NetworkResponse.noData.rawValue)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)

                    completion(apiReponse.items, nil)
                } catch {
                    completion([], NetworkResponse.unableToDecode.rawValue)
                }

            case .failure(let networkFailureError):
                completion([], networkFailureError)
            }
        }
    }
}
