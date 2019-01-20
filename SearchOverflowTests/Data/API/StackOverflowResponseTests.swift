//
//  StackOverflowResponseTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/20/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class StackOverflowResponseTests: XCTestCase {

    let decoder = JSONDecoder()
    
    override func setUp() { }
    
    override func tearDown() { }
    
    func test_Decodable_StackOResponseDecodingSucceeds() {
        guard let data = SearchOverflowTests.loadJSON(named: "StackOResponseDecodeSuccess") else {
            XCTFail()
            return
        }
        
        XCTAssertNoThrow(try decoder.decode(StackOverflowResponse<Answer>.self, from: data))
    }
    
    func test_Decodable_StackOResponseDecodingFails() {
        guard let data = SearchOverflowTests.loadJSON(named: "StackOResponseDecodeFailure") else {
            XCTFail()
            return
        }
        
        XCTAssertThrowsError(try decoder.decode(StackOverflowResponse<Answer>.self, from: data))
    }
}
