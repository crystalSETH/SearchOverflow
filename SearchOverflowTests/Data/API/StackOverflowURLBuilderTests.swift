//
//  StackOverflowURLBuilderTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 4/19/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class StackOverflowURLBuilderTests: XCTestCase {

    let searchUrl = URL(string: "https://api.stackexchange.com/2.2/search?page=1&order=desc&sort=votes&intitle=chicken&site=stackoverflow\(StackOverflow.filterParam)")!
    let questionUrl = URL(string: "https://api.stackexchange.com/2.2/questions/1?order=desc&sort=activity&site=stackoverflow\(StackOverflow.filterParam)")!

    func test_SearchBaseUrl() {
        let url = StackOverflow.search(for: "chicken", page: 1).baseURL
        XCTAssertEqual(url, searchUrl)
    }
    
    func test_QuestionBaseUrl() {
        let url = StackOverflow.question(id: 1).baseURL
        XCTAssertEqual(url, questionUrl)
    }
}
