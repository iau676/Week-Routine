//
//  Date+Extensions.swift
//  Week Routine
//
//  Created by ibrahim uysal on 14.12.2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
