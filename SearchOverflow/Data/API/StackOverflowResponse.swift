//
//  StackOverflowResponse.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

enum StackOverflowResponseError: Error {
    case unknownType
}

protocol StackOverflowResponseItem {
    associatedtype Item
    var hasMore: Bool { get }
    var quotaMax: Int { get }
    var quotaRemaining: Int { get }

    var type: StackOverflowItemType { get }
    var items: [Item] { get }

    var errorId: Int? { get }
    var errorName: String? { get }
    var errorMessage: String? { get }
}

class StackOverflowResponse<SOR: StackOverflowItem>: StackOverflowResponseItem, Decodable {
    typealias Item = SOR
    var hasMore: Bool
    var quotaMax: Int
    var quotaRemaining: Int

    var type: StackOverflowItemType
    var items: [Item]

    var errorId: Int?
    var errorName: String?
    var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case quotaMax = "quota_max"
        case quotaRemaining = "quota_remaining"
        case errorId = "error_id"
        case errorName = "error_name"
        case errorMessage = "error_message"

        case type
        case items
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        hasMore = try values.decode(Bool.self, forKey: .hasMore)
        quotaMax = try values.decode(Int.self, forKey: .quotaMax)
        quotaRemaining = try values.decode(Int.self, forKey: .quotaRemaining)

        let itemType = try values.decode(String.self, forKey: .type)

        type = StackOverflowItemType(rawValue: itemType) ?? .unknown

        items = try values.decode([Item].self, forKey: .items)

        errorId = try values.decodeIfPresent(Int.self, forKey: .errorId)
        errorName = try values.decodeIfPresent(String.self, forKey: .errorName)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
    }
}
