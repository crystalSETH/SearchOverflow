//
//  RouterTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class NetworkRouterTests: XCTestCase {

    var urlSession = MockUrlSession()
    var sut = NetworkRouter()
    let endPoint = MockEndPoint()

    override func setUp() {
        sut.session = urlSession
    }

    override func tearDown() {
        sut.cancel()
    }

    func test_Router_UsesExpectedURL() {

        sut.request(endPoint) { _, _, _ in }
        guard let url = urlSession.url else {
            XCTFail()
            return
        }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.url?.absoluteString, mockBaseURL + mockPath)
    }
    
    func test_Router_URLSessionTaskCreated() {

        sut.request(endPoint) { _, _, _ in }
        
        XCTAssertNotNil(sut.task)
    }

    func test_Router_RequestStartsURLSessionTask() {
        
        sut.request(endPoint) { _, _, _ in }

        XCTAssert(sut.task?.state == .running)
    }
    
    func test_Router_CancelStopsURLSessionTask() {
        
        sut.request(endPoint) { _, _, _ in }
        sut.cancel()
        
        XCTAssert(sut.task?.state == .canceling)
    }
    
    func test_Router_CompletesRequest() {
        
        let expectation = XCTestExpectation(description: "Router completes a web url request")
        sut.request(endPoint) { data, response, error in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - Mock
// MARK: End Point
private let mockBaseURL = "https://www.reddit.com"
private let mockPath = "/r/AustralianShepherd/"

struct MockEndPoint: EndPoint {
    var baseURL: URL = URL(string: mockBaseURL)!
    var path: String = mockPath
}

// MARK: URL Session
class MockUrlSession: URLSessionProtocol {
    var url: URL?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        self.url = request.url
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            completionHandler(nil, nil, nil)
        }

        return URLSession.shared.dataTask(with: request)
    }
}

