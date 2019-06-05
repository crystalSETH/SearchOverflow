//
//  AnswersTableViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class AnswersTableViewControllerTests: XCTestCase {
    
    var sut: AnswersTableViewController!
    private lazy var question: Question = {
        let question = Question(id: 1, owner: nil, score: 100, title: "Huckle", body: "Berry",
                                createdOn: Date(), tags: [], viewCount: 100, isAnswered: true,
                                answers: testAnswers, acceptedAnswerId: 3, answerCount: 4)
        
        return question
    }()
    
    private let testAnswers = [ Answer(id: 1, owner: User(id: 1, displayName: "John Stark", type: .registered,
                                                          reputation: 42, profileImageUrl: "https://avatars1.githubusercontent.com/u/7024589?s=460&v=4"),
                                       score: 100, title: "Howdy", body: "Doody",
                                       createdOn: Date(), tags: [], isAccepted: false, questionId: 1),
                                Answer(id: 2, owner: nil, score: 90, title: "", body: "",
                                       createdOn: Date(), tags: [], isAccepted: false, questionId: 1),
                                Answer(id: 3, owner: nil, score: 80, title: "", body: "",
                                       createdOn: Date(), tags: [], isAccepted: true, questionId: 1),
                                Answer(id: 4, owner: nil, score: 70, title: "", body: "",
                                       createdOn: Date(), tags: [], isAccepted: false, questionId: 1)
    ]
    
    override func setUp() {
        guard let answersVC = AnswersTableViewController.initializeFromStoryboard(with: question) else {
            XCTFail()
            return
        }
        
        sut = answersVC
        sut.question = question

        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_ViewDidLoad() {
        XCTAssertNotNil(sut.tableView.delegate)
        XCTAssertNotNil(sut.tableView.dataSource)
    }
    
    func test_TableView_NumberOfSections() {
        XCTAssertEqual(sut.tableView.numberOfSections, 1)
    }

    func test_TableView_NumberOfRows_Valid() {
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), question.answers?.count)
    }
    
    func test_TableView_NumberOfRows_Invalid() {
        sut.question = nil
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_TableView_CellForRowAt() {
        XCTAssertNotNil(sut.tableView(sut.tableView, cellForRowAt: IndexPath(item: 0, section: 0)))
    }
}
