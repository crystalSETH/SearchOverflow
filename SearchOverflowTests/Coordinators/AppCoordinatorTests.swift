//
//  AppCoordinatorTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 4/22/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class AppCoordinatorTests: XCTestCase {
    var sut: AppCoordinator?

    override func setUp() {
        sut = AppCoordinator(navigationController: UINavigationController())
        sut?.begin()
    }
    
    func test_CoordinatorBegan() {
        if sut?.navController.presentedViewController == nil, sut?.navController.viewControllers.isEmpty != false {
            XCTFail()
        }
    }
    
    func test_DisplaysQuestionDetails() {
        let question = Question(id: 0, owner: nil, score: 0, title: "", body: "", createdOn: Date(),
                                tags: [], viewCount: 0, isAnswered: false, answers: nil, acceptedAnswerId: nil, answerCount: 0)
        sut?.viewQuestionDetails(question)

        let expectation = XCTestExpectation(description: "QuestionDetails is displayed")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            if self.sut?.navController.topViewController is QuestionDetailsPageViewController {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
