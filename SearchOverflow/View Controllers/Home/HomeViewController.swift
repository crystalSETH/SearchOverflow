//
//  HomeViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTextField?.delegate = self
        searchTextField?.borderStyle = .none
        searchTextField?.layer.cornerRadius = 15
        searchTextField?.layer.masksToBounds = true

        let padding = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 15, height: 30)))
        searchTextField?.leftView = padding
        searchTextField?.leftViewMode = .always
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
