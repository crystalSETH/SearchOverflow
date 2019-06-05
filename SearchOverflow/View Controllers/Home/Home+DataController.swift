//
//  Home+DataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

// MARK: - Search Controller Delegate
extension HomeViewController: SearchControllerDelegate {
    
    func didBeginSearch(for title: String) {
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

    func didReceiveSearchResults(for title: String, results: [Question], page: Int) {

        // fill the array if needed
        if questionPages.isEmpty, let pages = stackOverflowSearchController?.numberOfPages {
            questionPages = Array<[Question]>(repeating: [], count: pages)
        }
    
        if stackOverflowSearchController?.numberOfPages != 0 {
            let questionsSorted = results.sorted(by: { $0.score > $1.score })
            questionPages[page - 1] = questionsSorted
        }

        // Reload the table if this is the first page
        if page == 1 {
            DispatchQueue.main.async {
                self.resultsTableView?.reloadData()
                self.resultsTableView?.isHidden = results.count == 0
                self.resultsTableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)

                self.noResultsImage.isHidden = results.count > 0
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
}
