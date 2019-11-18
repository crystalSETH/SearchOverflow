//
//  ApiRepository.swift
//  SearchOverflow
//
//  Created by Seth Folley on 11/17/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import Combine

protocol ApiRepository {
    var router: NetworkRouter { get }
}
