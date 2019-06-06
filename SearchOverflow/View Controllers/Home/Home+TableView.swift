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
        return questionDataController?.numberOfPages ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionDataController?.pageSize ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let question = question(for: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: Home.cellId) as? QuestionCell else { return UITableViewCell() }
        
        cell.questionTitleLabel.text = try? Down(markdownString: question.title).toAttributedString().string.trimmingCharacters(in: .newlines)
        
        let hasAcceptedAnswer = question.acceptedAnswerId != nil
        cell.scoreContainerView.backgroundColor = hasAcceptedAnswer ? Home.cellAnswerGreen : .clear
        cell.scoreContainerView.layer.cornerRadius = 3
        cell.scoreContainerView.layer.borderWidth = 1
        cell.scoreContainerView.layer.borderColor = (question.isAnswered ? Home.cellAnswerGreen : .gray).cgColor
        let score = question.score
        let scoreText: String
        if score / 1000 > 1 {
            scoreText = "\(score / 1000)k"
        } else {
            scoreText = "\(score)"
        }
        cell.scoreLabel.text = scoreText
        let scoreTextColor: UIColor
        if hasAcceptedAnswer {
            scoreTextColor = .white
        } else if question.isAnswered {
            scoreTextColor = Home.cellAnswerGreen
        }
        else {
            scoreTextColor = .darkGray
        }
        cell.scoreLabel.textColor = scoreTextColor
        cell.tagsLabel.text = "jimmy, cracked, corn, who, cares"
        cell.lastActivityDescriptionLabel.text = "\(indexPath.item + 2) mins ago"
        
        return cell
    }
    
    /// Convience method to retrieve question (if there is one) at the given index path. Based on the question pages.
    private func question(for indexPath: IndexPath) -> Question? {
        guard let controller = questionDataController else { return nil }
        
        let questionRespItems = controller.responseItems
        guard indexPath.section < questionRespItems.count,
              indexPath.item < questionRespItems[indexPath.section].items.count else { return nil }
        
        return questionRespItems[indexPath.section].items[indexPath.item]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let view = UIView()
        view.backgroundColor = Home.navBarColor
        cell.backgroundView = view
    }
}

// MARK: - Prefetching
extension HomeViewController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let controller = questionDataController else { return }
        
        let sections = indexPaths.map({ $0.section }).removingDuplicates()

        sections.forEach { section in
            let page = section + 1
            if !controller.responseItems.contains(where: { $0.page == page }), !controller.isLoadingPage(page) {
                controller.continueLoadingCurrentRequest(page: page)
            }
        }
    }
}

// MARK: - Delegate
extension HomeViewController: UITableViewDelegate {

    // Display the details for the question tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var requestedQuestion = question(for: indexPath) else { return }

        requestedQuestion.orderAnswers()
        coordintator?.viewQuestionDetails(requestedQuestion)
    }
}
