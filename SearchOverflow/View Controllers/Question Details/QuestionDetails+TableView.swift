//
//  QuestionDetails+TableView.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

extension QuestionDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalItems = question?.answers?.count ?? 0
        
        return totalItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let answer = question?.answers?[indexPath.item],
            let cell = tableView.dequeueReusableCell(withIdentifier: cAnswerCell.cellId) as? AnswerCell else { return UITableViewCell() }
        
        
        cell.gravatarImage.layer.cornerRadius = 5
        if let urlString = answer.owner?.profileImageUrl, let url = URL(string: urlString) {
            
            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: QuestionDetails.defaultGravatarName))
        }
        
        cell.answerDateLabel?.text = "answered \(answer.createdOn.prettyPrinted)"
        cell.scoreLabel?.text = "\(answer.score)"
        cell.usernameLabel?.text = answer.owner?.displayName ?? QuestionDetails.defaultUsername
        
        try? cell.markdownView?.update(markdownString: answer.body)
        
        cell.badgeImage.isHidden = !answer.isAccepted
        
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView
        
        cell.background.layer.cornerRadius = 15
        cell.background.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let aCell = cell as? AnswerCell {
            aCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
}

