//
//  Question.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// https://api.stackexchange.com/docs/types/question
/// Question model for the StackExchange API
struct Question: PostItem, StackOverflowItem {
    // Post Item vars
    var id: Int
    var owner: User?
    var score: Int
    var title: String
    var body: String
    var createdOn: Date
    var tags: [String]

    // Question Data
    var viewCount: Int
    var isAnswered: Bool
    var answers: [Answer]?
    var acceptedAnswerId: Int?
    var answerCount: Int

    enum CodingKeys: String, CodingKey {
        case id = "question_id"
        case createdOn = "creation_date"
        case viewCount = "view_count"
        case isAnswered = "is_answered"
        case acceptedAnswerId = "accepted_answer_id"
        case answerCount = "answer_count"

        case owner
        case score
        case title
        case body
        case tags
        case answers
    }
    
    /// Returns the answers ordered by score, but the accepted answer is always first
    mutating func orderAnswers() {
        self.answers?.sort(by: { $0.isAccepted || $0.score > $1.score })
    }
}
