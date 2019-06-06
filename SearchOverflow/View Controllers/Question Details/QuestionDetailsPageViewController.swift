//
//  QuestionDetailsPageViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 6/5/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

enum QuestionPageKeys: String {
    case details, answers
}

enum QuestionDetailControlSegment: String {
    case overview, answers
}

class QuestionDetailsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pages: [QuestionPageKeys : UIViewController] = [:]
    var currentIndex = 0

    private var segments: [QuestionDetailControlSegment] = [.overview, .answers]
    lazy var pageSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: segments.map({ $0.rawValue.capitalized }))
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentControlValueChanged), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        if let detailsVC = pages[.details] {
            setViewControllers([detailsVC], direction: .forward, animated: false, completion: nil)
        }
        
        navigationItem.titleView = pageSegmentControl
    }
    
    // MARK: Selectors
    @objc func segmentControlValueChanged() {
        let selectedValue = pageSegmentControl.selectedSegmentIndex
        if let segmenTitle = pageSegmentControl.titleForSegment(at: selectedValue)?.lowercased(),
            let selectedSegment = QuestionDetailControlSegment(rawValue: segmenTitle) {
            switch selectedSegment {
            case .overview:
                if currentIndex != 0, let detailsVC = pages[.details] {
                    currentIndex = 0
                    setViewControllers([detailsVC], direction: .reverse, animated: true, completion: nil)
                }
            case .answers:
                if currentIndex != 1, let answersVC = pages[.answers] {
                    currentIndex = 1
                    self.setViewControllers([answersVC], direction: .forward, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: Page VC Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard finished, completed else { return }
        
        if previousViewControllers.first is QuestionDetailsViewController {
            currentIndex = 1
        } else {
            currentIndex = 0
        }
        
        pageSegmentControl.selectedSegmentIndex = currentIndex
    }

    // MARK: Page VC Datasource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is AnswersTableViewController {
            return pages[.details]
        }
        else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is QuestionDetailsViewController {
            return pages[.answers]
        } else {
            return nil
        }
    }
}

