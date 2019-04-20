//
//  QuestionDetailsViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/14/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit
import Down

class QuestionDetailsViewController: BaseViewController {
    var question: Question?

    @IBOutlet weak var questionView: UIView?
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!

    @IBOutlet weak var gravatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var markdownView: DownView?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Results table setup
        let answerNib = UINib(nibName: cAnswerCell.nibId, bundle: nil)
        answersTableView?.register(answerNib, forCellReuseIdentifier: cAnswerCell.cellId)

        answersTableView.dataSource = self
        
        // Setup question details views
        usernameLabel.text = question?.owner?.displayName
        scoreLabel.text = "\(question?.score ?? 0)"

        let questionTitle = try? Down.init(markdownString: "\(question?.title ?? QuestionDetails.defaultTitle)").toAttributedString().string
        questionTitleLabel?.text = questionTitle

        gravatarImage.layer.cornerRadius = 3
        gravatarImage.layer.masksToBounds = true
        if let urlString = question?.owner?.profileImageUrl, let url = URL(string: urlString) {
            
            gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: QuestionDetails.defaultGravatarName))
        }
        
        // Setup markDownView
        markdownView = try? DownView(frame: .zero, markdownString: question?.body ?? QuestionDetails.defaultBody)
        markdownView?.layer.cornerRadius = 10
        markdownView?.layer.masksToBounds = true

        if let downView = markdownView, let qView = questionView {
            qView.addSubview(downView)
            
            downView.backgroundColor = .clear
            downView.translatesAutoresizingMaskIntoConstraints = false
            downView.leadingAnchor.constraint(equalTo: qView.leadingAnchor, constant: 9).isActive = true
            downView.trailingAnchor.constraint(equalTo: qView.trailingAnchor, constant: -9).isActive = true
            downView.topAnchor.constraint(equalTo: questionTitleLabel.bottomAnchor).isActive = true
            downView.bottomAnchor.constraint(equalTo: qView.bottomAnchor, constant: -6).isActive = true
        }
        
        // Dismiss button
        dismissButton.layer.borderWidth = 2
        dismissButton.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Add corner radius to "dismiss button"
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.layer.masksToBounds = true
    }

    // MARK: Selectors
    @IBAction func didTapDismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Convience
extension QuestionDetailsViewController {
    /// Creates a Question Details VC with the given question.
    static func initializeFromStoryboard(with question: Question) -> QuestionDetailsViewController? {
        let questionVC = UIStoryboard(name: QuestionDetails.storyboardId, bundle: nil)
                        .instantiateInitialViewController() as? QuestionDetailsViewController

        questionVC?.question = question

        return questionVC
    }
}
