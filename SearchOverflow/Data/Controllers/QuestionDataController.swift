//
//  QuestionDataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol QuestionDataControllerDelegate: class {
    func didBeginLoadingQuestions()
    func didReceiveQuestions(_ questions: [Question], forPage page: Int)
}

class QuestionDataController: BaseDataController, Pageable {
    weak var delegate: QuestionDataControllerDelegate?
    
    var router: Router
    
    private(set) var currentCategory: QuestionCategory?
    private(set) var currentSearchString: String?
    var isSearching: Bool {
        return currentSearchString != nil
    }

    private(set) var totalItems: Int = 0
    private(set) var pageSize: Int = 0
    
    // MARK: Lifecycle
    init(with router: Router) {
        self.router = router
    }
    
    func handleQuestionDataResponse(_ response: HTTPURLResponse, data: Data?, page: Int) {
        // Handle the network response, parse data, and call completion
        switch self.handleNetworkResponse(response) ?? Result.failure("") {
        case .success:
            guard let responseData = data else {
                return
            }
            do {
                // Try to parse the response data
                //                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)
                
                self.totalItems = apiReponse.total
                self.pageSize = apiReponse.pageSize
                
                // Completes with the question items, no error
                self.delegate?.didReceiveQuestions(apiReponse.items, forPage: page)
            } catch {
                // Complete with a parsing error
                self.delegate?.didReceiveQuestions([], forPage: page)
            }
            
        case .failure(_): break
            // Complete with a network error
            self.delegate?.didReceiveQuestions([], forPage: page)
        }
    }

    // MARK: Category Loading
    func load(category: QuestionCategory, page: Int) {
        currentCategory = category
        currentSearchString = nil

        page == 1 ? delegate?.didBeginLoadingQuestions() : nil

        let categoryEndpoint = StackOverflow.category(category, page: page)
        router.request(categoryEndpoint) { [weak self] data, response, error in
            guard error == nil, let urlResponse = response as? HTTPURLResponse else {
                return
            }
            
           self?.handleQuestionDataResponse(urlResponse, data: data, page: page)
        }
    }
    
    // MARK: - Search Functions
    /// Begins the search for the given title
    func beginSearch(for title: String) {
        currentSearchString = title
        currentCategory = nil
        
        search(for: title, page: 1)
    }
    
    /// Gets the next page of the search results
    func continueLoadingCurrentRequest(page: Int) {
        if let title = currentSearchString {
            search(for: title, page: page)
        }
        else if let category = currentCategory {
            load(category: category, page: page)
        }
    }
    
    private func search(for title: String, page: Int) {
        
        page == 1 ? delegate?.didBeginLoadingQuestions() : nil
        
        // Request data
        router.request(StackOverflow.search(for: title, page: page)) { [weak self] data, response, error in
            
            guard error == nil, let urlResponse = response as? HTTPURLResponse, self?.currentSearchString == title else {
                return
            }
            
            self?.handleQuestionDataResponse(urlResponse, data: data, page: page)
        }
    }
}
