//
//  SearchController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/19/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

enum QuestionCategory: Int, CaseIterable {
    case featured = 0
    case top
    case unanswered
    case noAnswers
    
    var displayText: String {
        switch self {
        case .featured: return "Featured"
        case .top: return "Top"
        case .unanswered: return "Unanswered"
        case .noAnswers: return "No Answers"
        }
    }
}

protocol CategoryControllerDelegate: class {
    func didBeginLoading(category: QuestionCategory)
    func didReceiveCategoryResults(for category: QuestionCategory, results: [Question], page: Int)
}

class CategoryDataController: BaseDataController, Pageable {
    weak var delegate: CategoryControllerDelegate?
    
    var router: Router
    
    private(set) var totalItems: Int = 0
    private(set) var pageSize: Int = 0
    
    // MARK: - Lifecycle
    init(with router: Router) {
        self.router = router
    }
    
    func load(category: QuestionCategory, page: Int) {
        let categoryRequest = StackOverflow.category(category, page: page)
        router.request(categoryRequest) { [weak self] data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                return
            }

            // Handle the network response, parse data, and call completion
            switch self?.handleNetworkResponse(urlResponse) ?? Result.failure("") {
            case .success:
                guard let responseData = data else {
                    return
                }
                do {
                    // Try to parse the response data
                    //                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)

                    self?.totalItems = apiReponse.total
                    self?.pageSize = apiReponse.pageSize

                    // Completes with the question items, no error
                    self?.delegate?.didReceiveCategoryResults(for: category, results: apiReponse.items, page: page)
                } catch {
                    // Complete with a parsing error
                    self?.delegate?.didReceiveCategoryResults(for: category, results: [], page: page)
                }

            case .failure(_): break
                // Complete with a network error
                self?.delegate?.didReceiveCategoryResults(for: category, results: [], page: page)
            }
        }
    }
}
