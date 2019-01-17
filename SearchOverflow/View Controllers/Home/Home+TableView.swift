//
//  Home+TableView.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit
import Down

// MARK: Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Home.cellId) as? QuestionCell else { return UITableViewCell() }
        
        let question = questions[indexPath.item]
        
        cell.gravatarImage.layer.cornerRadius = 5
        if let urlString = question.owner?.profileImageUrl, let url = URL(string: urlString) {
            
            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: Home.defaultGravatarName))
        }
        
        cell.usernameLabel?.text = question.owner?.displayName ?? Home.defaultUsername
        
        let questionTitle = try? Down.init(markdownString: "\(question.title)").toAttributedString().string
        cell.questionTitleLabel?.text = questionTitle
        cell.viewsLabel?.text = "\(question.viewCount)"
        cell.answersLabel?.text = "\(question.answerCount)"
        cell.scoreLabel?.text = "\(question.score)"
        
        try? cell.markdownView?.update(markdownString: question.body)
        
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView
        
        cell.background.layer.cornerRadius = 25
        cell.background.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let qCell = cell as? QuestionCell {
            qCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
}

// MARK: Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var requestedQuestion = questions[indexPath.item]
        requestedQuestion.answers = dataController.orderedAnswers(for: requestedQuestion)
        
        if let questionVC = QuestionDetailsViewController
            .initializeFromNib(with: requestedQuestion) {
            
            present(questionVC, animated: true)
        }
    }
}
