//
//  QuestionDetailsCoordinator.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/4/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

class QuestionDetailsCoordinator: NSObject, Coordinator {
    var childCoordinators: [CoordinatorType : Coordinator] = [:]
    var navController: UINavigationController
    
    var question: Question

    init(navigationController: UINavigationController, question: Question) {
        self.navController = navigationController
        self.question = question
        
        super.init()
    }

    func begin() {
        guard let pageVC = UIStoryboard(name: QuestionDetails.storyboardId, bundle: nil).instantiateInitialViewController() as? QuestionDetailsPageViewController else { return }

        guard let detailsVC = QuestionDetailsViewController.initializeFromStoryboard(with: question) else { return }
        
        detailsVC.question = question
        
        pageVC.pages[.details] = detailsVC
        pageVC.pages[.answers] = AnswersTableViewController()
        
        navController.pushViewController(pageVC, animated: true)
    }
}
