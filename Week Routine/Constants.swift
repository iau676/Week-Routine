//
//  Constants.swift
//  Week Routine
//
//  Created by ibrahim uysal on 8.10.2022.
//

import UIKit

enum Colors {
    static let backgroundColor           = UIColor(named: "backgroundColor")
    static let viewColor                 = UIColor(named: "viewColor")
    static let labelColor                = UIColor(named: "labelColor")
    static let blackColor                = UIColor(hex: "#1C1C1E")
}

enum UserDefault {
    static var selectedDayType           = UserDefaultsManager(key: "selectedDayType")
    static var keyboardHeight            = UserDefaultsManager(key: "keyboardHeight")
}
