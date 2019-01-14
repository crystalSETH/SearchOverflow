//
//  QuestionCell.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit
import Down

class QuestionCell: UITableViewCell {
    @IBOutlet weak var gravatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var lineView: UIView!

    var markdownView: DownView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    private func setupViews() {

        markdownView = try? DownView(frame: .zero, markdownString: "")

        if let downView = markdownView {
            addSubview(downView)

            downView.backgroundColor = .red
            downView.translatesAutoresizingMaskIntoConstraints = false
            downView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9).isActive = true
            downView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9).isActive = true
            downView.topAnchor.constraint(equalTo: questionTitleLabel.bottomAnchor).isActive = true
            downView.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -6).isActive = true
        }
    }
}
