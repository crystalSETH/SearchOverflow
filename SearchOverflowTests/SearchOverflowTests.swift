//
//  SearchOverflowTests.swift
//  SearchOverflowTests
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import XCTest
@testable import SearchOverflow

class SearchOverflowTests: XCTestCase {

    static func loadJSON(named jsonName: String) -> Data? {
        let bundle = Bundle(for: self)
        
        guard let url = bundle.url(forResource: jsonName, withExtension: "json"),
              let data = try? Data(contentsOf: url)
            else { return nil }
        
        return data
    }
}
