//
//  QuestionDetailsPageViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

class QuestionDetailsPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    var pages: [String : UIViewController] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let detailsVC = pages["Details"] {
            setViewControllers([detailsVC], direction: .forward, animated: false, completion: nil)
        }
    }
    
    // MARK: Page VC Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is QuestionDetailsViewController {
            return nil
        } else {
            return nil
        }
    }
}

