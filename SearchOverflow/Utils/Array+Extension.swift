//
//  Array+Extension.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/6/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    func removingDuplicates() -> [Element] {
        var uniqueArray: [Element] = []
        forEach { element in
            if !uniqueArray.contains(element) {
                uniqueArray.append(element)
            }
        }
        
        return uniqueArray
    }
    
    mutating func removeDuplicates() {
        self = removingDuplicates()
    }
}
