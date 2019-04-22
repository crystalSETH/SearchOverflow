//
//  AppCoordinator.swift
//  SearchOverflow
//
//  Created by Seth Folley on 4/22/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    private(set) var childCoordinators: [CoordinatorType : Coordinator] = [:]
    private(set) var navController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
        self.navController.isNavigationBarHidden = true
    }

    func begin() {
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
        self.navController.pushViewController(vc, animated: true)
    }
}
