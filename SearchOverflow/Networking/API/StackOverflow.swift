//
//  StackOverflow.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

private let baseURL = "https://api.stackexchange.com"

/* https://api.stackexchange.com/docs/filters
 * Filters are immutable and non-expiring. An application can safely "bake in" any filters that are created,
 * it is not necessary (or advisable) to create filters at runtime.
 */

let shallowQuestionFilter = "&filter=!-MOiNm42tgzzkEU(LzVlBT1xkCHN-0O_A"
let questionFilter = "&filter=!)s))yOCJcBsc9uLD71Rm"

/// StackOverflow API Endpoint
enum StackOverflow {
    case category(_ category: QuestionCategory, page: Int)
    case search(for: String, page: Int)
    case question(id: Int)
}

extension StackOverflow: EndPoint {
    var baseURL: URL {
        guard let url = URL(string: "https://api.stackexchange.com/2.2/")
            else { fatalError("Base url could not be configured.") }

        return url
    }

    var path: String {
        switch self {
        case .category(let category, let page):
            let categoryString: String
            switch category {
            case .featured: categoryString = "featured"
            case .noAnswers: categoryString = "no-answers"
            case .unanswered: categoryString = "unanswered"
            case .top: return "questions?page=\(page)&order=desc&sort=votes&site=stackoverflow" + questionFilter
            }
        
            return "questions/" + categoryString + "?page=\(page)&order=desc&sort=activity&site=stackoverflow" + questionFilter
    
        case .search(let text, let page):
            guard let textPercentEncoded = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                fatalError("Could not percent encode searched for text.")
            }
            return "search?page=\(page)&order=desc&sort=votes&intitle=\(textPercentEncoded)&site=stackoverflow" + questionFilter

        case .question(let id):
            return "questions/\(id)?order=desc&sort=activity&site=stackoverflow" + questionFilter
        }
    }
}
