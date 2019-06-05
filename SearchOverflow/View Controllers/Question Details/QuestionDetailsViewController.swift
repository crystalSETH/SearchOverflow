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

    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var markDownContainer: UIView!
    
    private var markdownView: DownView?

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DownOptions
        // Setup question details views
        scoreLabel.text = "\(question?.score ?? 0)"

        let questionTitle = try? Down.init(markdownString: "\(question?.title ?? QuestionDetails.defaultTitle)").toAttributedString().string
        questionTitleLabel?.text = questionTitle
        
        // Setup markDownView
        markdownView = try? DownView(frame: .zero, markdownString: question?.body ?? QuestionDetails.defaultBody)

        markdownView?.backgroundColor = .clear
        if let downView = markdownView, let container = markDownContainer {
            view.addSubview(downView)
            
            downView.backgroundColor = .clear
            downView.translatesAutoresizingMaskIntoConstraints = false
            downView.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
            downView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
            downView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            downView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
    }
}

// MARK: Convience
extension QuestionDetailsViewController {
    /// Creates a Question Details VC with the given question.
    static func initializeFromStoryboard(with question: Question) -> QuestionDetailsViewController? {
        let questionVC = UIStoryboard(name: QuestionDetails.storyboardId, bundle: nil)
                        .instantiateViewController(withIdentifier: "QuestionDetailsViewController") as? QuestionDetailsViewController

        questionVC?.question = question

        return questionVC
    }
}
