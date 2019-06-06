//
//  QuestionDataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
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
    
    private(set) var pagesLoading: [Int] = []
    private(set) var responseItems: [StackOverflowResponse<Question>] = []

    // MARK: Lifecycle
    init(with router: Router) {
        self.router = router
    }
    
    func resetForNewLoad() {
        responseItems.removeAll()
        pagesLoading.removeAll()
        currentSearchString = nil
        currentCategory = nil
    }

    func appendResponseItem(_ item: StackOverflowResponse<Question>) {
        // First try replacing the first occurance of this page
        for (index, arrayItem) in responseItems.enumerated() {
            if item.page == arrayItem.page {
                responseItems[index] = item
                return
            }
        }
        
        // Otherwise, append item and sort on page
        responseItems.append(item)
        responseItems.sort(by: { $0.page < $1.page })
    }

    func isLoadingPage(_ page: Int) -> Bool {
        return pagesLoading.contains(page)
    }

    func handleQuestionDataResponse(_ response: HTTPURLResponse, data: Data?, page: Int) {
        pagesLoading.removeAll(where: { $0 == page })

        print("Page \(page) loaded with status code: \(response.statusCode)")

        // Handle the network response, parse data, and call completion
        switch self.handleNetworkResponse(response) {
        case .success:
            guard let responseData = data else {
                return
            }
            do {
                // Try to parse the response data
                //let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)
                
                self.totalItems = apiReponse.total
                self.pageSize = apiReponse.pageSize
                
                self.appendResponseItem(apiReponse)

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
    func beginLoading(category: QuestionCategory) {
        resetForNewLoad()
        currentCategory = category
        
        load(category: category, page: 1)

        delegate?.didBeginLoadingQuestions()
    }

    func load(category: QuestionCategory, page: Int) {
        pagesLoading.append(page)

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
        resetForNewLoad()
        currentSearchString = title
        
        search(for: title, page: 1)
        delegate?.didBeginLoadingQuestions()
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
        pagesLoading.append(page)

        // Request data
        router.request(StackOverflow.search(for: title, page: page)) { [weak self] data, response, error in
            
            guard error == nil, let urlResponse = response as? HTTPURLResponse, self?.currentSearchString == title else {
                return
            }
            
            self?.handleQuestionDataResponse(urlResponse, data: data, page: page)
        }
    }
}
