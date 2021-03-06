//
//  StackOverflowResponse.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/12/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// StackOverflow response error descriptors
enum StackOverflowResponseError: Error {
    case unknownType
}

// StackOverflow response description
protocol StackOverflowResponseItem {
    associatedtype Item
    var hasMore: Bool { get }
    var page: Int { get }
    var pageSize: Int { get }
    var total: Int { get }

    var type: StackOverflowItemType { get }
    var items: [Item] { get }

    var errorId: Int? { get }
    var errorName: String? { get }
    var errorMessage: String? { get }
}

// https://api.stackexchange.com/docs/wrapper
/// The StackOverflow response item represents the response wrapper from the StackExchange API
struct StackOverflowResponse<SOR: StackOverflowItem>: StackOverflowResponseItem, Decodable {
    typealias Item = SOR
    var hasMore: Bool
    var page: Int
    var pageSize: Int
    var total: Int

    var type: StackOverflowItemType
    var items: [Item]

    var errorId: Int?
    var errorName: String?
    var errorMessage: String?

    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case pageSize = "page_size"

        case errorId = "error_id"
        case errorName = "error_name"
        case errorMessage = "error_message"

        case page
        case type
        case items
        case total
    }
}
