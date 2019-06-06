//
//  ExtensionsTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class ExtensionsTests: XCTestCase {

    func test_Color_HexInit() {
        XCTAssertNotNil(UIColor(hexString: "FFFFFF"))
    }
    
    func test_Color_CGColor() {
        XCTAssertNotNil(UIColor.red.cgColor.uiColor)
    }

    func test_Date_Printing() {
        XCTAssertNotNil(Date().prettyPrinted)
        XCTAssertNotNil(Date().prettyPrintedInCurrentTimeZoneWithOutYear)
    }

    func test_Font_PrintsAll() {
        UIFont.printAvailableFonts()
    }
}
