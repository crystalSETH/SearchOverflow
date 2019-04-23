//
//  StackOverflowItem.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

/// Descriptor of the StackOverflow response items' type
enum StackOverflowItemType: String, Codable {
    case answer
    case question
    case user
    case unknown
}

/// Base for StackOverflow API Items
protocol StackOverflowItem: Decodable { }
