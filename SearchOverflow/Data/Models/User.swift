//
//  User.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

enum UserType: String {
    case unregistered
    case registered
    case moderator
    case teamAdmin = "team_admin"
    case dne = "does_not_exist"
}

// https://api.stackexchange.com/docs/types/shallow-user
/// User model for the StackExchange API (shallow_user)
struct User {
    var id: Int
    var displayName: String?
    var type: UserType
    var reputation: Int?
    var profileImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case displayName = "display_name"
        case type = "user_type"
        case profileImageUrl = "profile_image"

        case reputation
    }
}

// MARK: - Decodable
extension User: StackOverflowItem, Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(Int.self, forKey: .id)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)

        let userTypeString = try values.decode(String.self, forKey: .type)
        type = UserType(rawValue: userTypeString) ?? .dne

        reputation = try values.decode(Int.self, forKey: .reputation)
        profileImageUrl = try values.decode(String.self, forKey: .profileImageUrl)
    }
}
