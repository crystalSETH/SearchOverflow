//
//  HomeViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit
import Down
import Kingfisher
import NVActivityIndicatorView

class HomeViewController: BaseViewController {
    weak var coordintator: AppCoordinator?
    
    @IBOutlet weak var resultsTableView: UITableView?
    @IBOutlet weak var noResultsImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryPickerBottomConstraint: NSLayoutConstraint!

    var isPickerViewShowing: Bool {
        return categoryPickerBottomConstraint.priority > categoryPickerTopConstraint.priority
    }
    
    lazy var categoryNavButton: QuestionCategoryNavigationButton = {
        let view = QuestionCategoryNavigationButton.instantiateFromNib()!
        view.categoryLabel.text = "Featured"
        view.categoryLabel.textColor = Home.navBarItemTintColor
        view.indicatorImageView.tintColor = Home.navBarItemTintColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCategoryPicker)))
        return view
    }()
    
    private(set) lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = "Search Stack Overflow"
        return controller
    }()

    var searchDataController: SearchDataController? {
        didSet {
            searchDataController?.delegate = self
        }
    }

        didSet {
            stackOverflowSearchController?.delegate = self
        }
    }
    
    var questionPages: [[Question]] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Home.navBarColor

        setupNavigationBar()

        configureViews()
    }

    private func setupNavigationBar() {
        categoryNavButton.sizeToFit()
        navigationItem.titleView = categoryNavButton
        
        let searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchNavItem))
        searchBarItem.tintColor = Home.navBarItemTintColor
        navigationItem.rightBarButtonItem = searchBarItem
        
        let stackOBarItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "Stack O Logo")))
        stackOBarItem.customView?.contentMode = .scaleAspectFit
        stackOBarItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        navigationItem.leftBarButtonItem = stackOBarItem
        
        navigationController?.navigationBar.tintColor = Home.navBarItemTintColor
        navigationController?.navigationBar.barTintColor = Home.navBarColor

        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = .darkText
            if let backgroundview = textfield.subviews.first {
                // Background color
                backgroundview.backgroundColor = Home.navBarItemTintColor
                
                backgroundview.layer.cornerRadius = 10
                backgroundview.layer.masksToBounds = false
            }
        }
        // ensure search controller stays on this VC
        definesPresentationContext = true
    }

    private func configureViews() {
        resultsTableView?.backgroundColor = Home.navBarColor
        let background = UIView(frame: .zero)
        resultsTableView?.backgroundView = background

        resultsTableView?.showsVerticalScrollIndicator = false
        resultsTableView?.dataSource = self
        resultsTableView?.prefetchDataSource = self
        resultsTableView?.delegate = self
        
        // Category picker setup
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
    }
    
    // MARK: Selectors
    @objc func didTapSearchNavItem() {
        if navigationItem.searchController == nil {
            navigationItem.searchController = searchController
        }
    }

    @objc func toggleCategoryPicker() {
        isPickerViewShowing ? hideCategoryPicker() : showCategoryPicker()
    }
    
    @IBAction func doneTappedForPickerView(_ sender: Any) {
        let row = categoryPickerView.selectedRow(inComponent: 0)
        let category = QuestionCategory(rawValue: row)

        hideCategoryPicker()
        categoryNavButton.categoryLabel.text = category?.displayText
        
        // TODO: Reload data for selected category
    }

    func showCategoryPicker() {
        categoryPickerBottomConstraint.priority = UILayoutPriority(999)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideCategoryPicker() {
        categoryPickerBottomConstraint.priority = .defaultHigh

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - Search Bar Delegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 0 else { return }

        searchDataController?.beginSearch(for: text)
    }
}

// MARK: - Picker View
extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Picker View Datasource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return QuestionCategory.allCases.count
    }
    
    // MARK: Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return QuestionCategory(rawValue: row)?.displayText
    }
}
