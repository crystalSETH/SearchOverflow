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

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField?
    @IBOutlet weak var resultsTableView: UITableView?
    @IBOutlet weak var noResultsImage: UIImageView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
//    private var activityView = NVActivityIndicatorView(frame: .zero, type: .ballClipRotateMultiple , color: .white)
    
    private lazy var dataController: QuestionsController = {
        let qController = QuestionsController(with: NetworkRouter())
        qController.delegate = self
        return qController
    }()

    private var questions: [Question] = [] {
        didSet {
            resultsTableView?.reloadData()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let questionNib = UINib(nibName: "QuestionCell", bundle: nil)
        resultsTableView?.register(questionNib, forCellReuseIdentifier: "QuestionCell")

        resultsTableView?.backgroundColor = .clear
        let background = UIView(frame: .zero)
        resultsTableView?.backgroundView = background

        resultsTableView?.showsVerticalScrollIndicator = false
        resultsTableView?.dataSource = self
        resultsTableView?.delegate = self
    }
}

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

// MARK: - Table View
// MARK: Datasource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalItems = questions.count

        return totalItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell") as? QuestionCell else { return UITableViewCell() }

        let question = questions[indexPath.item]

        cell.gravatarImage.layer.cornerRadius = 5
        if let urlString = question.owner?.profileImageUrl, let url = URL(string: urlString) {

            cell.gravatarImage.kf.setImage(with: url, placeholder: UIImage(named: "DefaultGravatar"))
        }

        cell.usernameLabel?.text = question.owner?.displayName ?? "No Username"

        let questionTitle = try? Down.init(markdownString: "\(question.title)").toAttributedString().string
        cell.questionTitleLabel?.text = questionTitle
        cell.viewsLabel?.text = "\(question.viewCount)"
        cell.answersLabel?.text = "\(question.answerCount)"
        cell.scoreLabel?.text = "\(question.score)"

        try? cell.markdownView?.update(markdownString: question.body)

        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = .clear
        cell.backgroundView = bgView

        cell.background.layer.cornerRadius = 25
        cell.background.layer.masksToBounds = true
        
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let qCell = cell as? QuestionCell {
            qCell.gravatarImage.kf.cancelDownloadTask()
        }
    }
}

// MARK: Delegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var requestedQuestion = questions[indexPath.item]
        requestedQuestion.answers = dataController.orderedAnswers(for: requestedQuestion)

        if let questionVC = QuestionDetailsViewController
                            .initializeFromNib(with: requestedQuestion) {

            present(questionVC, animated: true)
        }
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

        dataController.search(for: text)
    }
}
