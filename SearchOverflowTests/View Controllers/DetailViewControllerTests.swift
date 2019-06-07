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
                                    createdOn: 12345, tags: [], viewCount: 100, isAnswered: true,
                                    answers: testAnswers, acceptedAnswerId: 3, answerCount: 4)
        
        return question
    }()

    private let testAnswers = [ Answer(id: 1, owner: User(id: 1, displayName: "John Stark", type: .registered,
                                                          reputation: 42, profileImageUrl: "https://avatars1.githubusercontent.com/u/7024589?s=460&v=4"),
                                       score: 100, title: "Howdy", body: "Doody",
                                       createdOn: 12345, tags: [], isAccepted: false, questionId: 1),
                                Answer(id: 2, owner: nil, score: 90, title: "", body: "",
                                       createdOn: 12345, tags: [], isAccepted: false, questionId: 1),
                                Answer(id: 3, owner: nil, score: 80, title: "", body: "",
                                       createdOn: 12345, tags: [], isAccepted: true, questionId: 1),
                                Answer(id: 4, owner: nil, score: 70, title: "", body: "",
                                       createdOn: 12345, tags: [], isAccepted: false, questionId: 1)
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
    
    func test_ViewLoadsData() {
        XCTAssertNotNil(sut.questionTitleLabel.text)
        XCTAssertNotNil(sut.markdownView)
        XCTAssertNotNil(sut.scoreLabel.text)
    }
}
