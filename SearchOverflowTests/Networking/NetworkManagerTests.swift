//
//  NetworkManagerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!
    var router = NetworkRouter<MockEndPoint>()

    override func setUp() {
        sut = NetworkManager(with: router)
    }

    override func tearDown() {
    }

    func test_NetworkResponseHandlerSuccess() {
        let successfulStatusCodes = [200, 205, 248, 281, 299]

        for code in successfulStatusCodes {
            guard let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: code, httpVersion: nil, headerFields: nil)
                else { fatalError() }

            let result = sut.handleNetworkResponse(response)

            switch result {
            case .success: XCTAssert(true)
            default: XCTFail()
            }
        }
    }

    func test_NetworkResponseFailure() {
        let failureStatusCodes = [400, 500, 600, -192, 30789, 1]

        for code in failureStatusCodes {
            guard let response = HTTPURLResponse(url: URL(fileURLWithPath: ""), statusCode: code, httpVersion: nil, headerFields: nil)
                else { fatalError() }

            let result = sut.handleNetworkResponse(response)

            switch result {
            case .failure(_): XCTAssert(true)
            default: XCTFail()
            }
        }
    }
}
