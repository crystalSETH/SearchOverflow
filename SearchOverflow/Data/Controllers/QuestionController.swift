//
//  QuestionsController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

final class QuestionController: BaseDataController {

    /// Returns the answers ordered by score, but the accepted answer is always first
    static func orderedAnswers(for question: Question) -> [Answer] {
        var tempQ = question
        tempQ.answers?.sort(by: { $0.isAccepted || $0.score > $1.score })
        
        return question.answers?.sorted(by: { $0.isAccepted || $0.score > $1.score }) ?? []
    }
}
