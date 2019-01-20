//
//  SearchController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/19/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol SearchControllerDelegate: class {
    func didBeginSearch(for title: String)
    func didReceiveSearchResults(for title: String, results: [Question], page: Int)
}

/// Search Controller that assists searching for strings in question titles.
class SearchController: BaseDataController {
    weak var delegate: SearchControllerDelegate?
    
    var router: Router
    
    private(set) var currentSearchString: String?
    
    private(set) var totalItems: Int = 0
    private(set) var pageSize: Int = 0
    
    var numberOfPages: Int {
        
        return pageSize > 0 ? totalItems / pageSize : 0
    }
    
    // MARK: - Lifecycle
    init(with router: Router) {
        self.router = router
    }
    
    // MARK: - Search Functions
    /// Begins the search for the given title
    func beginSearch(for title: String) {
        currentSearchString = title
        
        search(for: title, page: 1)
    }
    
    /// Gets the next page of the search results
    func continueSearch(page: Int) {
        guard let title = currentSearchString else { return }

        search(for: title, page: page)
    }
    
    private func search(for title: String, page: Int) {

        page == 1 ? delegate?.didBeginSearch(for: title) : nil

        // Request data
        router.request(StackOverflow.search(for: title, page: page)) { [weak self] data, response, error in
            
            guard error == nil, let urlResponse = response as? HTTPURLResponse, self?.currentSearchString == title else {
                self?.delegate?.didReceiveSearchResults(for: title, results: [], page: page)
                return
            }
            
            // Handle the network response, parse data, and call completion
            switch self?.handleNetworkResponse(urlResponse) ?? Result.failure("") {
            case .success:
                guard let responseData = data else {
                    self?.delegate?.didReceiveSearchResults(for: title, results: [], page: page)
                    return
                }
                do {
                    // Try to parse the response data
                    //                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                    let apiReponse = try JSONDecoder().decode(StackOverflowResponse<Question>.self, from: responseData)
                    
                    self?.totalItems = apiReponse.total
                    self?.pageSize = apiReponse.pageSize
                    
                    // Completes with the question items, no error
                    self?.delegate?.didReceiveSearchResults(for: title, results: apiReponse.items, page: apiReponse.page)
                } catch {
                    // Complete with a parsing error
                    self?.delegate?.didReceiveSearchResults(for: title, results: [], page: page)
                }
                
            case .failure(_):
                // Complete with a network error
                self?.delegate?.didReceiveSearchResults(for: title, results: [], page: page)
            }
        }
    }
}
