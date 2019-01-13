//
//  ViewController.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    let networkManager = NetworkManager(with: NetworkRouter<StackOverflow>())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

