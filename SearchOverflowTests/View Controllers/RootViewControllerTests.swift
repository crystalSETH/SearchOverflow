//
//  RootViewControllerTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 4/19/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class RootViewControllerTests: XCTestCase {

    var sut: RootViewController!
    
    override func setUp() {
        guard let homeVC = UIStoryboard(name: "Root", bundle: nil).instantiateInitialViewController() as? RootViewController else {
                XCTFail()
                return
        }
        
        sut = homeVC
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_RootVC_loadsView() {
        XCTAssert(sut.isViewLoaded)
    }
}
