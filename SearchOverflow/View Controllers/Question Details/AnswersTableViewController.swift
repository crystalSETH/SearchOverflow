//
//  AnswersTableViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit
import Down

class AnswersTableViewController: UITableViewController {
    var question: Question?

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalItems = question?.answers?.count ?? 0
        
        return totalItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let answer = question?.answers?[indexPath.item],
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableCell") as? AnswerTableCell else { return UITableViewCell() }
        
        // setup user metadata
//        cell.usernameLabel?.text = answer.owner?.displayName ?? QuestionDetails.defaultUsername
//        cell.gravatarImage.layer.cornerRadius = 5
//        if let urlString = answer.owner?.profileImageUrl, let url = URL(string: urlString) {
//            
//            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: QuestionDetails.defaultGravatarName))
//        }
//        
//        // setup answer metadata
//        cell.answerDateLabel?.text = "answered \(answer.createdOn.prettyPrinted)"
        cell.scoreLabel?.text = "\(answer.score)"
        
        try? cell.markdownView?.update(markdownString: answer.body)
        
        cell.answerIndicator.isHidden = !answer.isAccepted
        
        // additional cell setup
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView
        
//        cell.background.layer.cornerRadius = 15
//        cell.background.layer.masksToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the image download task if the cell has finished displaying
        if let aCell = cell as? AnswerTableCell {
//            aCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
}

extension AnswersTableViewController {
    /// Creates a Question Details VC with the given question.
    static func initializeFromStoryboard(with question: Question) -> AnswersTableViewController? {
        let answersVC = UIStoryboard(name: QuestionDetails.storyboardId, bundle: nil)
            .instantiateViewController(withIdentifier: "AnswersTableViewController") as? AnswersTableViewController
        
        answersVC?.question = question
        
        return answersVC
    }
}

class AnswerTableCell: UITableViewCell {
    @IBOutlet weak var markDownContainer: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answerIndicator: UIImageView!
    
    var markdownView: DownView?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        scoreLabel.text = nil
        try? markdownView?.update(markdownString: "")
    }
    
    private func setupViews() {
        answerIndicator.image = answerIndicator.image?.withRenderingMode(.alwaysTemplate)
        answerIndicator.tintColor = #colorLiteral(red: 0.2632682621, green: 0.6104809642, blue: 0.3705400229, alpha: 1)

        // Setup markDownView
        markdownView = try? DownView(frame: .zero, markdownString: "")
        
        if let downView = markdownView {
            addSubview(downView)
            
            downView.backgroundColor = .clear
            downView.translatesAutoresizingMaskIntoConstraints = false
            downView.leadingAnchor.constraint(equalTo: markDownContainer.leadingAnchor).isActive = true
            downView.trailingAnchor.constraint(equalTo: markDownContainer.trailingAnchor).isActive = true
            downView.topAnchor.constraint(equalTo: markDownContainer.topAnchor).isActive = true
            downView.bottomAnchor.constraint(equalTo: markDownContainer.bottomAnchor).isActive = true
        }
    }
}
