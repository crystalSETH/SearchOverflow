//
//  QuestionModelTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class AnswerModelTests: XCTestCase {
    
    let decoder = JSONDecoder()

    override func setUp() { }
    
    override func tearDown() { }
    
    func test_Decodable_AnswerDecodingSucceeds() {
        guard let data = SearchOverflowTests.loadJSON(named: "AnswerDecodeSuccess") else {
            XCTFail()
            return
        }
        
        XCTAssertNoThrow(try decoder.decode(Answer.self, from: data))
    }
    
    func test_Decodable_AnswerDecodingFails() {
        guard let data = SearchOverflowTests.loadJSON(named: "AnswerDecodeFailure") else {
            XCTFail()
            return
        }
        
        XCTAssertThrowsError(try decoder.decode(Answer.self, from: data))
    }
}
