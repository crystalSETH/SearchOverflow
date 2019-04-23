//
//  UIView+Extension.swift
//  SearchOverflow
//
//  Created by Seth Folley on 4/22/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // https://theiconic.tech/instantiating-from-xib-using-swift-generics-632a2b3d8109
    static func instantiateFromNib() -> Self? {
        func instanceFromNib<T: UIView>() -> T? {
            return UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
        }
        
        return instanceFromNib()
    }
}
