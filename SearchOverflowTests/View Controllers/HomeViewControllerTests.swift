//
//  HomeViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class HomeViewControllerTests: XCTestCase {
    var router: NetworkRouter!
    var sut: HomeViewController!

    override func setUp() {
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil)
            .instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
                XCTFail()
                return
        }
        
        sut = homeVC
        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.protocolClasses = [MockQuestionURLProtocol.self]
        router = ApiRouter(sessionConfig: sessionConfig)
        let mockDataController = MockQuestionController(with: router)
        mockDataController.test_TotalItems = 10
        mockDataController.test_PageSize = 3

        sut.questionDataController = mockDataController

        sut.loadViewIfNeeded()
        
        sut.questionDataController?.beginSearch(for: "")
    }

    override func tearDown() {
        router = nil
        sut = nil
    }

    // MARK: Selector Tests
    func test_HomeVC_SearchItemTapped() {
        sut.didTapSearchNavItem()
        XCTAssertNotNil(sut.navigationItem.searchController)
    }

    func test_HomeVC_ToggleCategoryPicker() {
        let initialPickerIsShowing = sut.isPickerViewShowing
        sut.toggleCategoryPicker()
        XCTAssert(initialPickerIsShowing != sut.isPickerViewShowing)
    }

    func test_HomeVC_DoneTappedForPicker() {
        sut.showCategoryPicker()
        sut.doneTappedForPickerView(sut.categoryPickerView)
        
        XCTAssertFalse(sut.isPickerViewShowing)
    }

    // MARK: Misc Home Setup tests
    func test_HomeVC_HandlesTableView() {

        guard let safeSut = sut, let tableView = sut?.resultsTableView else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(safeSut, tableView.dataSource as? HomeViewController)
        XCTAssertEqual(safeSut, tableView.prefetchDataSource as? HomeViewController)
        XCTAssertEqual(safeSut, tableView.delegate as? HomeViewController)
    }

    func test_HomeVC_IsDataControllerDelegate() {
        
        XCTAssertEqual(sut, sut.questionDataController?.delegate as? HomeViewController)
    }

    // MARK: Table View Tests
    func test_TableView_IsNotNil() {

        XCTAssertNotNil(sut.resultsTableView)
    }
    
    func test_TableView_NumberOfSections_Case1() {
    
        let mockDataController = MockQuestionController(with: router)
        mockDataController.test_TotalItems = 9
        mockDataController.test_PageSize = 3
        
        sut.questionDataController = mockDataController
        
        XCTAssertEqual(sut.resultsTableView?.numberOfSections, 3)
    }
    
    func test_TableView_NumberOfSections_Case2() {
        
        XCTAssertEqual(sut.resultsTableView?.numberOfSections, 4)
    }
    
    func test_TableView_NumberOfRowsInSection() {
        
        XCTAssertEqual(sut.resultsTableView?.numberOfRows(inSection: 0), 3)
    }
    
    func test_TableView_QuestionCellForRowAt() {
        let cell = sut.tableView(sut.resultsTableView!, cellForRowAt: IndexPath(item: 0, section: 0)) as? QuestionCell
        
        XCTAssertNotNil(cell)
    }
    
    func test_TableView_QuestionCellReuse() {
        let cell = sut.tableView(sut.resultsTableView!, cellForRowAt: IndexPath(item: 0, section: 0)) as? QuestionCell
        cell?.prepareForReuse()

        XCTAssertNotNil(cell)
        XCTAssertNil(cell?.questionTitleLabel.text)
        XCTAssertNil(cell?.tagsLabel.text)
        XCTAssertNil(cell?.scoreLabel.text)
        XCTAssertNil(cell?.lastActivityDescriptionLabel.text)
    }    
}

class MockQuestionController: QuestionDataController {
    var test_TotalItems = 0
    override var totalItems: Int {
        get {
            return test_TotalItems
        }
    }
    
    var test_PageSize = 0
    override var pageSize: Int {
        get {
            return test_PageSize
        }
    }

    override var responseItems: [StackOverflowResponse<Question>] {
        get {
            return [StackOverflowResponse<Question>(hasMore: false,
                                                   page: 0,
                                                   pageSize: pageSize,
                                                   total: totalItems,
                                                   type: .question,
                                                   items: [Question(id: 0,
                                                                    owner: nil,
                                                                    score: 0,
                                                                    title: "",
                                                                    body: "",
                                                                    createdOn: 0,
                                                                    tags: [],
                                                                    viewCount: 0,
                                                                    isAnswered: true,
                                                                    answers: nil,
                                                                    acceptedAnswerId: nil,
                                                                    answerCount: 0)],
                                                   errorId: nil,
                                                   errorName: nil,
                                                   errorMessage: nil)]
        }
    }
}

class MockQuestionURLProtocol: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [URL?: Data]()

    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        // …and if we have test data for that URL…
        if let data = SearchOverflowTests.loadJSON(named: "SearchResponse p\(1)") {
            // …load it immediately.
            self.client?.urlProtocol(self, didLoad: data)
        }

        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }

    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}
