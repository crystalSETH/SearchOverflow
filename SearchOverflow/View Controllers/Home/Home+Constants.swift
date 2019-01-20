//
//  Home+Constants.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

typealias Home = Constants.Home

extension Constants {
    struct Home {
        static let cellId = "QuestionCell"
        static let searchingFont = UIFont(name: "AvenirNextCondensed-Medium", size: 21)
        static let placeholderFont = UIFont(name: "AvenirNextCondensed-MediumItalic", size: 21)

        static let selectedCellColor = UIColor(hexString: "dcdde1")
        static let unselectedCellColor = UIColor.white
        
        static let defaultUsername = "No Username"
        static let defaultGravatarName = "DefaultGravatar"
    }
}
