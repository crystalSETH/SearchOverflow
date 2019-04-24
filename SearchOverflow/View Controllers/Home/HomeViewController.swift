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
    
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var resultsTableView: UITableView?
    @IBOutlet weak var noResultsImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var categoryPickerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryPickerBottomConstraint: NSLayoutConstraint!
    private var isPickerViewShowing: Bool {
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
    
    var searchController: SearchController? {
        didSet {
            searchController?.delegate = self
        }
    }

    var questionPages: [[Question]] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        categoryNavButton.sizeToFit()
        navigationItem.titleView = categoryNavButton

        let searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchNavItem))
        searchBarItem.tintColor = Home.navBarItemTintColor
        navigationItem.rightBarButtonItem = searchBarItem

        let stackOBarItem = UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "Stack O Logo")))
        stackOBarItem.customView?.contentMode = .scaleAspectFit
//        stackOBarItem.customView?.widthAnchor.constraint(equalToConstant: 28).isActive = true
        stackOBarItem.customView?.heightAnchor.constraint(equalToConstant: 28).isActive = true
        navigationItem.leftBarButtonItem = stackOBarItem
        
        navigationController?.navigationBar.tintColor = Home.navBarItemTintColor
        navigationController?.navigationBar.barTintColor = Home.navBarColor

        configureViews()
    }

    private func configureViews() {
        // Search text field setup
        searchTextField?.delegate = self
        searchTextField?.borderStyle = .none
        searchTextField?.layer.cornerRadius = 15
        searchTextField?.layer.masksToBounds = true

        // Add padding to left side of text field
        let padding = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 30)))
        searchTextField?.leftView = padding
        searchTextField?.leftViewMode = .always

        // Results table setup
        let questionNib = UINib(nibName: Home.cellId, bundle: nil)
        resultsTableView?.register(questionNib, forCellReuseIdentifier: Home.cellId)

        resultsTableView?.layer.cornerRadius = 12
        resultsTableView?.layer.masksToBounds = true
        resultsTableView?.backgroundColor = .clear
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
    @objc private func didTapSearchNavItem() {
        
    }

    @objc private func toggleCategoryPicker() {
        isPickerViewShowing ? hideCategoryPicker() : showCategoryPicker()
    }
    
    @IBAction func doneTappedForPickerView(_ sender: Any) {
        let row = categoryPickerView.selectedRow(inComponent: 0)
        let category = QuestionCategory(rawValue: row)

        hideCategoryPicker()
        categoryNavButton.categoryLabel.text = category?.displayText
        
        // TODO: Reload data for selected category
    }

    private func showCategoryPicker() {
        categoryPickerBottomConstraint.priority = UILayoutPriority(999)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideCategoryPicker() {
        categoryPickerBottomConstraint.priority = .defaultHigh

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
// MARK: - Picker View
extension HomeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    enum QuestionCategory: Int, CaseIterable {
        case featured = 0
        case top
        case unanswered
        case noAnswers
        
        var displayText: String {
            switch self {
            case .featured: return "Featured"
            case .top: return "Top"
            case .unanswered: return "Unanswered"
            case .noAnswers: return "No Answers"
            }
        }
    }

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

// MARK: - Text Field Delegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismisses the keyboard
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text, text.count > 0 else { return }

        searchController?.beginSearch(for: text)
    }
}
