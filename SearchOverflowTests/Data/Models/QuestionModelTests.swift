//
//  QuestionModelTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class QuestionModelTests: XCTestCase {

    let decoder = JSONDecoder()

    override func setUp() { }

    override func tearDown() { }
    
    func test_Decodable_QuestionDecodingSucceeds() {
        guard let data = SearchOverflowTests.loadJSON(named: "QuestionDecodeSuccess") else {
            XCTFail()
            return
        }
        
        XCTAssertNoThrow(try decoder.decode(Question.self, from: data))
    }
    
    func test_Decodable_QuestionDecodingFails() {
        guard let data = SearchOverflowTests.loadJSON(named: "QuestionDecodeFailure") else {
            XCTFail()
            return
        }
        
        XCTAssertThrowsError(try decoder.decode(Question.self, from: data))
    }
}
