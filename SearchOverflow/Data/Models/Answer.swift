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
struct Answer: PostItem {
    // Post Item vars
    var id: Int
    var owner: User?
    var score: Int
    var title: String
    var body: String
    var createdOn: Date
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

// MARK: - Decodable
extension Answer: StackOverflowItem, Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        owner = try values.decodeIfPresent(User.self, forKey: .owner)
        score = try values.decode(Int.self, forKey: .score)
        title = try values.decode(String.self, forKey: .title)
        body = try values.decode(String.self, forKey: .body)
        createdOn = try values.decode(Date.self, forKey: .createdOn)
        tags = try values.decode([String].self, forKey: .tags)

        isAccepted = try values.decode(Bool.self, forKey: .isAccepted)
        questionId = try values.decode(Int.self, forKey: .questionId)
    }
}
