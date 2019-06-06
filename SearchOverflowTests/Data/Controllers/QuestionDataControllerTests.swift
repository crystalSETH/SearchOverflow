//
//  QuestionDataControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 6/6/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class SearchControllerTests: XCTestCase, QuestionDataControllerDelegate {
    
    let searchString = "Huckleberry"
    
    lazy var sut: QuestionDataController = {
        let controller = QuestionDataController(with: router)
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
    
    override func setUp() { }
    
    override func tearDown() {
        delegateSearchTitle = ""
        delegateSearchPage = -1
        searchResults = nil
        
        searchBeganExpectation = nil
        searchBeganResultExpectation = nil
        searchContinuedResultExpectation = nil
        
        router.requestedPage = 1
    }
    // MARK: Helpers
    func test_QDC_AppendResponseItems() {
        // Test we append items
        let firstMockResp = StackOverflowResponse<Question>(hasMore: true, page: 1, pageSize: 30, total: 300,
                                                            type: .question, items: [],
                                                            errorId: nil, errorName: nil, errorMessage: nil)
        sut.appendResponseItem(firstMockResp)
        XCTAssertFalse(sut.responseItems.isEmpty)
        
        // Test the items are sorted by page asc
        let secondMock = StackOverflowResponse<Question>(hasMore: true, page: 2, pageSize: 30, total: 300,
                                                         type: .question, items: [],
                                                         errorId: nil, errorName: nil, errorMessage: nil)
        sut.appendResponseItem(secondMock)
        XCTAssert(sut.responseItems.last?.page == 2)
        
        // Test the replace functionality
        let thirdMock = StackOverflowResponse<Question>(hasMore: true, page: 2, pageSize: 15, total: 300,
                                                        type: .question, items: [],
                                                        errorId: nil, errorName: nil, errorMessage: nil)
        sut.appendResponseItem(thirdMock)
        XCTAssert(sut.responseItems.count == 2)
        XCTAssert(sut.responseItems.last?.pageSize == 15)
    }

    // MARK: Search
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
    
    func test_Search_ContinuesSearchAndPageAndTitleIsExpected() {
        searchBeganResultExpectation = expectation(description: "Search Began Result")
        
        sut.beginSearch(for: searchString)
        
        wait(for: [searchBeganResultExpectation], timeout: 10)
        XCTAssertEqual(searchString, delegateSearchTitle)
        XCTAssertEqual(delegateSearchPage, 1)
        
        searchContinuedResultExpectation = expectation(description: "Search Continued Result")
        router.requestedPage = 2
        sut.continueLoadingCurrentRequest(page: 2)
        
        wait(for: [searchContinuedResultExpectation], timeout: 10)
        XCTAssertEqual(searchString, delegateSearchTitle)
        XCTAssertEqual(delegateSearchPage, 2)
    }
    
    // MARK: Search Datasource Delegate
    func didBeginLoadingQuestions() {
        delegateSearchTitle = sut.currentSearchString!
        
        searchBeganExpectation?.fulfill()
    }
    
    func didReceiveQuestions(_ questions: [Question], forPage page: Int) {
        delegateSearchTitle = sut.currentSearchString!
        delegateSearchPage = page
        searchResults = questions
        
        page == 1 ? searchBeganResultExpectation?.fulfill() :
            searchContinuedResultExpectation?.fulfill()
    }
}

fileprivate class MockSearchRouter: Router {
    let successResponse = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: 200, httpVersion: nil, headerFields: nil)
    
    var requestedPage = 1
    
    func request(_ route: EndPoint, completion: @escaping RouterCompletion) {
        
        let data = SearchOverflowTests.loadJSON(named: "SearchResponse p\(requestedPage)")
        completion(data, successResponse, nil)
    }
    
    func cancel() { }
}
