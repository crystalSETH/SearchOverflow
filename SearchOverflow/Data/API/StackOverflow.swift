//
//  StackOverflow.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

private let baseURL = "https://api.stackexchange.com"
private let filterParam = "&filter=!)rFTNPeZ)ZtF80-uQ9q9"

enum StackOverflow {
    case search(for: String)
    case question(id: Int)
}

extension StackOverflow: EndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://api.stackexchange.com" + path + filterParam)
            else { fatalError("Base url could not be configured.") }

        return url
    }

    var path: String {
        switch self {
        case .search(let text):
            guard let textPercentEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                fatalError("Could not percent encode searched for text.")
            }
            return "/2.2/search?order=desc&sort=activity&intitle=\(textPercentEncoded)&site=stackoverflow"

        case .question(let id):
            return "/2.2/questions/\(id)?order=desc&sort=activity&site=stackoverflow"
        }
    }
}
