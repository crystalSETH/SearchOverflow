//
//  QuestionModelTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class UserModelTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    override func setUp() { }
    
    override func tearDown() { }
    
    func test_Decodable_UserDecodingSucceeds() {
        guard let data = SearchOverflowTests.loadJSON(named: "UserDecodeSuccess") else {
            XCTFail()
            return
        }
        
        XCTAssertNoThrow(try decoder.decode(User.self, from: data))
    }
    
    func test_Decodable_UserDecodingFails() {
        guard let data = SearchOverflowTests.loadJSON(named: "UserDecodeFailure") else {
            XCTFail()
            return
        }
        
        XCTAssertThrowsError(try decoder.decode(User.self, from: data))
    }
}
