//
//  QuestionDetails+TableView.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

// MARK: Datasource
extension QuestionDetailsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalItems = question?.answers?.count ?? 0
        
        return totalItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let answer = question?.answers?[indexPath.item],
            let cell = tableView.dequeueReusableCell(withIdentifier: cAnswerCell.cellId) as? AnswerCell else { return UITableViewCell() }
        
        // setup user metadata
        cell.usernameLabel?.text = answer.owner?.displayName ?? QuestionDetails.defaultUsername
        cell.gravatarImage.layer.cornerRadius = 5
        if let urlString = answer.owner?.profileImageUrl, let url = URL(string: urlString) {
            
            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: QuestionDetails.defaultGravatarName))
        }
        
        // setup answer metadata
        cell.answerDateLabel?.text = "answered \(answer.createdOn.prettyPrinted)"
        cell.scoreLabel?.text = "\(answer.score)"
        
        try? cell.markdownView?.update(markdownString: answer.body)
        
        cell.badgeImage.isHidden = !answer.isAccepted
        
        // additional cell setup
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView
        
        cell.background.layer.cornerRadius = 15
        cell.background.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the image download task if the cell has finished displaying
        if let aCell = cell as? AnswerCell {
            aCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
}

