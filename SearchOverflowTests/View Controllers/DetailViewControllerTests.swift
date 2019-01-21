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
    
    override func setUp() {
        guard let questionDetailsVC = UIStoryboard(name: "QuestionDetails", bundle: nil)
            .instantiateViewController(withIdentifier: "QuestionDetailsViewController") as? QuestionDetailsViewController
        else {
            XCTFail()
            return
        }
        
        sut = questionDetailsVC
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
    
    func test_QDVC_IsAnswerTableDatasource() {
        
        XCTAssertEqual(sut, sut.answersTableView.dataSource as? QuestionDetailsViewController)
    }
    
    func test_QDVC_AnswerTableNumberOfRows() {
        let question = Question(id: 1, owner: nil, score: 100, title: "Huckle", body: "Berry",
                                createdOn: Date(), tags: [], viewCount: 100, isAnswered: true,
                                answers: testAnswers, acceptedAnswerId: 3, answerCount: 4)
        
        sut.question = question

        XCTAssertEqual(question.answers?.count, sut.answersTableView.numberOfRows(inSection: 0))
    }
}

private let testAnswers = [ Answer(id: 1, owner: nil, score: 100, title: "", body: "",
                                   createdOn: Date(), tags: [], isAccepted: false, questionId: 1),
                            Answer(id: 2, owner: nil, score: 90, title: "", body: "",
                                   createdOn: Date(), tags: [], isAccepted: false, questionId: 1),
                            Answer(id: 3, owner: nil, score: 80, title: "", body: "",
                                   createdOn: Date(), tags: [], isAccepted: true, questionId: 1),
                            Answer(id: 4, owner: nil, score: 70, title: "", body: "",
                                   createdOn: Date(), tags: [], isAccepted: false, questionId: 1)
                          ]
