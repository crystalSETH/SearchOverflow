//
//  Coordinator.swift
//  SearchOverflow
//
//  Created by Seth Folley on 4/22/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [CoordinatorType : Coordinator] { get }
    var navController: UINavigationController { get }
    func begin()
}

enum CoordinatorType: String {
    case questionDetails
}
