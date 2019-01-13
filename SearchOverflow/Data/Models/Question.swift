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
struct Question: PostItem {
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
}

// MARK: - Decodable
extension Question: StackOverflowItem, Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        owner = try values.decodeIfPresent(User.self, forKey: .owner)
        score = try values.decode(Int.self, forKey: .score)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        createdOn = try values.decode(Date.self, forKey: .createdOn)
        tags = try values.decode([String].self, forKey: .tags)

        viewCount = try values.decode(Int.self, forKey: .viewCount)
        isAnswered = try values.decode(Bool.self, forKey: .isAnswered)
        answers = try values.decodeIfPresent([Answer].self, forKey: .answers)
        acceptedAnswerId = try values.decodeIfPresent(Int.self, forKey: .acceptedAnswerId)
        answerCount = try values.decode(Int.self, forKey: .answerCount)
    }
}
