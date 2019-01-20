//
//  QuestionControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class QuestionControllerTests: XCTestCase {
    let question = Question(id: 1, owner: nil, score: 0, title: "", body: "",
                            createdOn: Date(), tags: [], viewCount: 0, isAnswered: true,
                            answers: testAnswers, acceptedAnswerId: 3, answerCount: 4)

    override func setUp() { }
    override func tearDown() { }

    func test_AnswersAreNotEmptyGivenAtLeastOneAnswer() {

        XCTAssert(!QuestionController.orderedAnswers(for: question).isEmpty)
    }
    
    func test_AnswerHasAcceptedFirst() {

        XCTAssert(QuestionController.orderedAnswers(for: question)[0].isAccepted)
    }
    
    func test_AnswersAreOrderedByScoreAfterAccepted() {
        var qcOrderedAnswers = QuestionController.orderedAnswers(for: question)
                                                 .filter({ !$0.isAccepted }) // filtered accepted answers

        // use the same answers passed to orderedAnswers
        var testOrderedAnswers = question.answers!.filter({ !$0.isAccepted })
        testOrderedAnswers.sort(by: { $0.score > $1.score })
        
        for i in 0..<qcOrderedAnswers.count {
            XCTAssert(qcOrderedAnswers[i].score == testOrderedAnswers[i].score)
        }
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
