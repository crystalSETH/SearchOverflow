//
//  StackOverflowRepository.swift
//  SearchOverflow
//
//  Created by Seth Folley on 11/18/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import Combine

struct StackOverflowRepository: ApiRepository {
    let router: NetworkRouter

    func loadQuestions(withId id: Int) -> AnyPublisher<[Question], NetworkError> {
        return router.request(StackOverflow.question(id: id))
    }

    func loadQuestions(inCategory category: QuestionCategory) -> AnyPublisher<[Question], NetworkError> {
        return router.request(StackOverflow.category(category, page: 0))
    }

    func search(for searchString: String) -> AnyPublisher<[Question], NetworkError> {
        return router.request(StackOverflow.search(for: searchString, page: 0))
    }
}
