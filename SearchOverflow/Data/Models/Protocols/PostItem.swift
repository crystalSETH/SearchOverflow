//
//  PostItem.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// https://api.stackexchange.com/docs/types/post
/// This item represents the intersection of the Question and Answer items.
protocol PostItem {
    var id: Int { get set }
    var owner: User? { get set }
    var score: Int { get set }
    var title: String { get set }
    var body: String { get set }
    var createdOn: TimeInterval { get set }
    var tags: [String] { get set }
}
