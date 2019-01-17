//
//  QuestionDetails+Constants.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/14/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

typealias QuestionDetails = Constants.QuestionDetails
typealias cAnswerCell = QuestionDetails.AnswerCell

extension Constants {
    struct QuestionDetails {
        static let storyboardId = "QuestionDetails"
        static let defaultUsername = "unknown"
        static let defaultGravatarName = "DefaultGravatar"
        static let defaultTitle = "No Title"
        static let defaultBody = "No Additional Details"

        struct AnswerCell {
            static let cellId = "AnswerCell"
            static let nibId = "AnswerCell"
        }
    }
}
