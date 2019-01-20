//
//  Date+Extension.swift
//  SearchOverflow
//
//  Created by Seth Folley on 1/14/19.
//  Copyright © 2019 Seth Folley. All rights reserved.
//

import Foundation

extension Date {
    /// Returns string for data printed in MMM dd 'YY format
    var prettyPrinted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd ''YY"

        let prettyString = formatter.string(from: self)

        return prettyString
    }

    var prettyPrintedInCurrentTimeZoneWithOutYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, h:mma"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"

        let prettyString = formatter.string(from: self)

        return prettyString + " " + (TimeZone.current.abbreviation() ?? "")
    }
}
