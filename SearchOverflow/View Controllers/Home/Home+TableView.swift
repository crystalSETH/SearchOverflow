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

        return searchController?.numberOfPages ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController?.pageSize ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let question = question(for: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: Home.cellId) as? QuestionCell else { return UITableViewCell() }
        
        cell.questionTitleLabel.text = try? Down(markdownString: question.title).toAttributedString().string.trimmingCharacters(in: .newlines)
        cell.scoreContainerView.layer.cornerRadius = 3
        cell.scoreContainerView.layer.borderWidth = 1
        cell.scoreContainerView.layer.borderColor = UIColor.gray.cgColor
        cell.scoreLabel.text = "\(question.score)"
        cell.tagsLabel.text = "jimmy, cracked, corn, who, cares"
        cell.lastActivityDescriptionLabel.text = "\(indexPath.item + 2) mins ago"
        
        return cell
    }
    
    /// Convience method to retrieve question (if there is one) at the given index path. Based on the question pages.
    private func question(for indexPath: IndexPath) -> Question? {
        guard indexPath.section < questionPages.count, indexPath.item < questionPages[indexPath.section].count else { return nil }
        
        return questionPages[indexPath.section][indexPath.row]
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

        guard let maxSection = indexPaths.map({ $0.section }).max(), maxSection < questionPages.count else { return }

        // check for sections(pages) that don't already have data
        let sections = indexPaths.filter({ questionPages[$0.section].isEmpty }).map({ $0.section })

        // request search results for pages not in the question pages
        for section in sections {
            searchController?.continueSearch(page: section + 1)
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
