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
    }
    
    func test_CoordinatorBegins() {
        sut?.begin()
        
        if sut?.navController.presentedViewController == nil, sut?.navController.viewControllers.isEmpty != false {
            XCTFail()
        }
    }
}
