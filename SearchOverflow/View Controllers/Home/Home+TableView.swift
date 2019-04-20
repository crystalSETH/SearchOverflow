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

    func numberOfSections(in tableView: UITableView) -> Int {

        return dataController.numberOfPages
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataController.pageSize
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let question = question(for: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: Home.cellId) as? QuestionCell else { return UITableViewCell() }
        
        // setup user metadata
        cell.usernameLabel?.text = question.owner?.displayName ?? Home.defaultUsername

        cell.gravatarImage.layer.cornerRadius = 5
        if let urlString = question.owner?.profileImageUrl, let url = URL(string: urlString) {
            
            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: Home.defaultGravatarName))
        }
        
        // setup question metadata
        let questionTitle = try? Down.init(markdownString: "\(question.title)").toAttributedString().string
        cell.questionTitleLabel?.text = questionTitle
        cell.viewsLabel?.text = "\(question.viewCount)"
        cell.answersLabel?.text = "\(question.answerCount)"
        cell.scoreLabel?.text = "\(question.score)"
        
        try? cell.markdownView?.update(markdownString: question.body)
        
        // additional cell setup
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView
        
        cell.background.layer.cornerRadius = 12
        cell.background.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the image download task if the cell has finished displaying
        if let qCell = cell as? QuestionCell {
            qCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
    
    /// Convience method to retrieve question (if there is one) at the given index path. Based on the question pages.
    private func question(for indexPath: IndexPath) -> Question? {
        guard indexPath.section < questionPages.count, indexPath.item < questionPages[indexPath.section].count else { return nil }
        
        return questionPages[indexPath.section][indexPath.row]
    }
}

// MARK: - Prefetching
extension HomeViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        guard let maxSection = indexPaths.map({ $0.section }).max(), maxSection < questionPages.count else { return }

        // check for sections(pages) that don't already have data
        let sections = indexPaths.filter({ questionPages[$0.section].isEmpty }).map({ $0.section })

        // request search results for pages not in the question pages
        for section in sections {
            dataController.continueSearch(page: section + 1)
        }
    }
}

// MARK: - Delegate
extension HomeViewController: UITableViewDelegate {

    // Display the details for the question tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var requestedQuestion = question(for: indexPath) else { return }

        requestedQuestion.answers = QuestionController.orderedAnswers(for: requestedQuestion)
        
        if let questionVC = QuestionDetailsViewController
            .initializeFromStoryboard(with: requestedQuestion) {
            
            present(questionVC, animated: true)
        }
    }
}
