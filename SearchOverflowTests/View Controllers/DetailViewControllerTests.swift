//
//  DetailViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class DetailViewControllerTests: XCTestCase {

    var sut: QuestionDetailsViewController!
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
        guard let questionDetailsVC = QuestionDetailsViewController.initializeFromStoryboard(with: question) else {
            XCTFail()
            return
        }
        
        sut = questionDetailsVC
        sut.question = question
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
    }

    func test_QuestionView_IsNotNil() {
        
        XCTAssertNotNil(sut.questionView)
    }
    
    func test_AnswerTable_IsNotNil() {
        
        XCTAssertNotNil(sut.answersTableView)
    }
    
    func test_DismissButton_IsNotNil() {

        XCTAssertNotNil(sut.dismissButton)
    }
    
    // MARK: Table View Tests
    func test_QDVC_IsAnswerTableDatasource() {
        XCTAssertEqual(sut, sut.answersTableView.dataSource as? QuestionDetailsViewController)
    }
    
    func test_QDVC_AnswerTableNumberOfRows() {
        XCTAssertEqual(question.answers?.count, sut.answersTableView.numberOfRows(inSection: 0))
    }
    
    func test_QDVC_AnswerTableNumberOfRows_nilQuestion() {
        sut.question = nil
        XCTAssertEqual(sut.answersTableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_QDVC_AnswerTableCellForRowAt() {
        let answer = (sut.question?.answers?.first)!
        let cell = sut.tableView(sut.answersTableView, cellForRowAt: IndexPath(item: 0, section: 0)) as! AnswerCell
        XCTAssertEqual(cell.usernameLabel.text, answer.owner!.displayName)
        XCTAssertNotNil(cell.gravatarImage.kf.placeholder)
    }
    
    func test_QDVC_AnswerTableCellForRowAt_nilOwner() {
        let cell = sut.tableView(sut.answersTableView, cellForRowAt: IndexPath(item: 1, section: 0)) as! AnswerCell
        XCTAssertEqual(cell.usernameLabel.text, QuestionDetails.defaultUsername)
    }

    func test_QDVC_AnswerTableCellForRowAt_nilQuestion() {
        let cell = sut.answersTableView.cellForRow(at: IndexPath(item: 0, section: 0))
        XCTAssertFalse(cell is AnswerCell)
    }
}
