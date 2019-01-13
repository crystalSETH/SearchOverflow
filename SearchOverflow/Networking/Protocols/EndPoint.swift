//
//  EndPoint.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/11/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

protocol EndPoint {
    var baseURL: URL { get }
    var path: String { get }
}
