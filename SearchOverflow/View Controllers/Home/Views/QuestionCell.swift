//
//  QuestionCell.swift
//  SearchOverflow
//
//  Created by Seth Folley on 4/24/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet weak var scoreContainerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var lastActivityDescriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        scoreLabel.text = nil
        questionTitleLabel.text = nil
        tagsLabel.text = nil
        lastActivityDescriptionLabel.text = nil
    }
}
