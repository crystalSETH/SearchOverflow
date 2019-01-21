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

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        gravatarImage.image = nil
        usernameLabel.text = nil
        questionTitleLabel.text = nil
        viewsLabel.text = nil
        scoreLabel.text = nil
        answersLabel.text = nil

        try? markdownView?.update(markdownString: "")
    }

    private func setupViews() {
        // Setup markDownView
        markdownView = try? DownView(frame: .zero, markdownString: "")

        if let downView = markdownView {

            downView.scrollView.isScrollEnabled = false
            downView.isUserInteractionEnabled = false
            addSubview(downView)

            downView.backgroundColor = .clear
            downView.translatesAutoresizingMaskIntoConstraints = false
            downView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 9).isActive = true
            downView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -9).isActive = true
            downView.topAnchor.constraint(equalTo: gravatarImage.bottomAnchor).isActive = true
            downView.bottomAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -6).isActive = true
        }
    }
}
