//
//  Home+DataController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

extension HomeViewController: QuestionsControllerDelegate {
    func didBeginSearch(for title: String) {
        noResultsImage.isHidden = true
        
        // start loading animation
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func didFinishSearch(for title: String, results: [Question]) {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.noResultsImage.isHidden = results.count > 0
            
            // finish loading animation
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            
            let questionsSorted = results.sorted(by: { $0.score > $1.score })
            self?.questions = questionsSorted
        }
    }
    
}
