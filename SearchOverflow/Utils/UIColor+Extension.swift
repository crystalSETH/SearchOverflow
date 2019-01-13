//
//  UIColor+Extension.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/13/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import UIKit

extension UIColor {

    /// Initializes a UIColor from a hex string.
    public convenience init?(hexString: String) {
        let cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        let index1 = cString.characters.index(cString.startIndex, offsetBy: 2)
        let index2 = cString.characters.index(index1, offsetBy: 2)

        let rString = cString.substring(to: index1)
        let gString = cString.substring(to: index2).substring(from: index1)
        let bString = cString.substring(from: index2)

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)

        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        return
    }
}

extension CGColor {
    var uiColor: UIColor? {
        return UIColor(cgColor: self)
    }
}
