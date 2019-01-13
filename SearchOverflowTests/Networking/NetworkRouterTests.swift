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
    var sut = NetworkRouter<MockEndPoint>()

    override func setUp() {
        sut.session = urlSession
    }

    override func tearDown() { }

    func test_Router_UsesExpectedURL() {
        let urlSession = MockUrlSession()
        let sut = NetworkRouter<MockEndPoint>()
        sut.session = urlSession

        sut.request(MockEndPoint()) { _, _, _ in }
        guard let url = urlSession.url else {
            XCTFail()
            return
        }

        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertEqual(urlComponents?.url?.absoluteString, mockBaseURL + mockPath)
    }
}

// MARK: - Mock
// MARK: End Point
private let mockBaseURL = "https://www.reddit.com"
private let mockPath = "/r/AustralianShepherd/"

struct MockEndPoint: EndPoint {
    var baseURL: URL = URL(string: mockBaseURL + mockPath)!
    var path: String = mockPath
}

// MARK: URL Session
class MockUrlSession: URLSessionProtocol {
    var url: URL?
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        self.url = request.url
        return URLSession.shared.dataTask(with: request)
    }
}

