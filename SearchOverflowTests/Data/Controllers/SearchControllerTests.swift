//
//  SearchControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/19/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class SearchControllerTests: XCTestCase, SearchControllerDelegate {

    let searchString = "Huckleberry"

    lazy var sut: SearchController = {
        let controller = SearchController(with: router)
        controller.delegate = self
        return controller
    }()

    private let router = MockSearchRouter()
    
    var searchBeganExpectation: XCTestExpectation!
    var searchBeganResultExpectation: XCTestExpectation!
    
    var searchContinuedResultExpectation: XCTestExpectation!

    var delegateSearchTitle = ""
    var delegateSearchPage = -1
    var searchResults: [Question]?

    override func setUp() {
    }

    override func tearDown() {

        delegateSearchTitle = ""
        searchBeganExpectation = nil
        delegateSearchPage = -1
        searchResults = nil
    }
    
    func test_Search_CurrentSearchStringIsExpected() {

        sut.beginSearch(for: searchString)
        
        XCTAssertEqual(sut.currentSearchString, searchString)
    }
    
    func test_Search_SearchBeginsAndTitleIsExpected() {

        searchBeganExpectation = expectation(description: "Search Began")
        
        sut.beginSearch(for: searchString)

        wait(for: [searchBeganExpectation], timeout: 10)
        
        XCTAssertEqual(searchString, delegateSearchTitle)
    }


    // MARK: Search Datasource Delegate
    func didBeginSearch(for title: String) {
        delegateSearchTitle = title
        
        searchBeganExpectation?.fulfill()
    }
    
    func didReceiveSearchResults(for title: String, results: [Question], page: Int) {
        delegateSearchTitle = title
        delegateSearchPage = page
        searchResults = results

        page == 1 ? searchBeganResultExpectation?.fulfill() : searchContinuedResultExpectation?.fulfill()
    }
}

fileprivate class MockSearchRouter: Router {
    let successResponse = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 100, httpVersion: nil, headerFields: nil)

    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {

        let data = SearchOverflowTests.loadJSON(named: "SearchResponse")
        completion(data, successResponse, nil)
    }
    
    func cancel() { }
}
