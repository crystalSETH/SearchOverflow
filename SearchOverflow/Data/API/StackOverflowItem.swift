//
//  StackOverflowItem.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

enum StackOverflowItemType: String {
    case answer
    case question
    case user
    case unknown
}

protocol StackOverflowItem: Decodable { }
