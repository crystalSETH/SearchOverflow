//
//  QuestionsController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol QuestionsControllerDelegate: class {
    func didBeginSearch(for title: String)
    func didFinishSearch(for title: String, results: [Question])
}

final class QuestionsController: BaseDataController {
    var router: Router
    weak var delegate: QuestionsControllerDelegate?

    init(with router: Router) {
        self.router = router
    }

    func orderedAnswers(for question: Question) -> [Answer] {
        var tempQ = question
        tempQ.answers?.sort(by: { $0.isAccepted || $0.score > $1.score })
        
        return question.answers?.sorted(by: { $0.isAccepted || $0.score > $1.score }) ?? []
    }

    func search(for title: String) {
        // Request data
        router.request(StackOverflow.search(for: title)) { [weak self] data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                self?.delegate?.didFinishSearch(for: title, results: [])
                return
            }
            
            // Handle the network response, parse data, and call completion
            switch self?.handleNetworkResponse(urlResponse) ?? Result.failure("") {
            case .success:
                guard let responseData = data else {
                    self?.delegate?.didFinishSearch(for: title, results: [])
                    return
                }
                do {
                    // Try to parse the response data
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)

                    // Completes with the question items, no error
                    self?.delegate?.didFinishSearch(for: title, results: apiReponse.items)
                } catch {
                    // Complete with a parsing error
                    self?.delegate?.didFinishSearch(for: title, results: [])
                }
                
            case .failure(_):
                // Complete with a network error
                self?.delegate?.didFinishSearch(for: title, results: [])
            }
        }
    }
}
