//
//  QuestionCell.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet weak var gravatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var background: UIView!
}
