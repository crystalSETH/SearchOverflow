//
//  User.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

enum UserType: String, Decodable {
    case unregistered
    case registered
    case moderator
    case teamAdmin = "team_admin"
    case dne = "does_not_exist"
}

// https://api.stackexchange.com/docs/types/shallow-user
/// User model for the StackExchange API (shallow_user)
struct User: StackOverflowItem {
    var id: Int?
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
