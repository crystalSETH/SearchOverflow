//
//  Answer.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// https://api.stackexchange.com/docs/types/answer
/// Answer model for the StackExchange API
struct Answer: PostItem, StackOverflowItem {
    // Post Item vars
    var id: Int
    var owner: User?
    var score: Int
    var title: String
    var body: String
    var createdOn: TimeInterval
    var tags: [String]

    // Answer metadata
    var isAccepted: Bool
    var questionId: Int

    enum CodingKeys: String, CodingKey {
        case id = "answer_id"
        case createdOn = "creation_date"
        case isAccepted = "is_accepted"
        case questionId = "question_id"

        case owner
        case score
        case title
        case body
        case tags
    }
}
