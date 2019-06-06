//
//  Pageable.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol Pageable {
    var totalItems: Int { get }
    var pageSize: Int { get }
    var maxNumberOfPages: Int { get set }
}

extension Pageable {
    var numberOfPages: Int {
        
        let pages: Int
        if pageSize > 0 {
            
            let fPages = (Float(totalItems) / Float(pageSize)).rounded(.up)
            
            pages = Int(fPages)
        }
        else { pages = 0}
        
        return pages > maxNumberOfPages ? maxNumberOfPages : pages
    }
}
