//
//  Home+DataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

extension HomeViewController {
    func questionsBeganLoading() {
        DispatchQueue.main.async {
            // reset table data
            self.questionPages = []
            
            self.resultsTableView?.reloadData()
            self.resultsTableView?.isHidden = true
            
            self.noResultsImage.isHidden = true
            
            // start loading animation
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func firstPageLoaded(with questions: [Question]) {
        DispatchQueue.main.async {
            self.resultsTableView?.reloadData()
            self.resultsTableView?.isHidden = questions.count == 0
            self.resultsTableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
            self.noResultsImage.isHidden = questions.count > 0
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
}
// MARK: - Question Data Controller Delegate
extension HomeViewController: QuestionDataControllerDelegate {
    func didBeginLoadingQuestions() {
        questionsBeganLoading()

        if questionDataController?.isSearching == true {
            self.searchController.isActive = false
        }
    }
    
    func didReceiveQuestions(_ questions: [Question], forPage page: Int) {
        // fill the array if needed
        if questionPages.isEmpty, let pages = questionDataController?.numberOfPages {
            questionPages = Array<[Question]>(repeating: [], count: pages)
        }
        
        if questionDataController?.numberOfPages != 0 {
            let questionsSorted = questions.sorted(by: { $0.score > $1.score })
            questionPages[page - 1] = questionsSorted
        }
        
        // Reload the table if this is the first page
        if page == 1 {
            firstPageLoaded(with: questions)
        }
    }
}
