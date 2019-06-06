//
//  QuestionPageViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class DetailsPageViewControllerTests: XCTestCase {
    
    var sut: QuestionDetailsPageViewController!
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
        guard let questionDetailsVC = UIStoryboard(name: QuestionDetails.storyboardId, bundle: nil).instantiateInitialViewController() as? QuestionDetailsPageViewController else {
            XCTFail()
            return
        }
        
        sut = questionDetailsVC
        sut.pages[.details] = QuestionDetailsViewController.initializeFromStoryboard(with: question)
        sut.pages[.answers] = AnswersTableViewController.initializeFromStoryboard(with: question)

        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_ViewDidLoad() {
        XCTAssertNotNil(sut.delegate)
        XCTAssertNotNil(sut.dataSource)
    }
    
    func test_SegmentControl_updatesCurrentIndex() {
        sut.pageSegmentControl.selectedSegmentIndex = 1
        sut.segmentControlValueChanged()
        XCTAssertEqual(sut.pageSegmentControl.selectedSegmentIndex, sut.currentIndex)
        
        sut.pageSegmentControl.selectedSegmentIndex = 0
        sut.segmentControlValueChanged()
        XCTAssertEqual(sut.pageSegmentControl.selectedSegmentIndex, sut.currentIndex)
    }
    
    func test_PageVCDataSource_VCBefore_Valid() {
        XCTAssert(sut.pageViewController(sut, viewControllerBefore: AnswersTableViewController()) is QuestionDetailsViewController)
    }
    
    func test_PageVCDataSource_VCBefore_Invalid() {
        XCTAssertNil(sut.pageViewController(sut, viewControllerBefore: UIViewController()))
    }
    
    func test_PageVCDataSource_VCAfter_Valid() {
        XCTAssert(sut.pageViewController(sut, viewControllerAfter: QuestionDetailsViewController()) is AnswersTableViewController)
    }
    
    func test_PageVCDataSource_VCAfter_Invalid() {
        XCTAssertNil(sut.pageViewController(sut, viewControllerAfter: UIViewController()))
    }
}
