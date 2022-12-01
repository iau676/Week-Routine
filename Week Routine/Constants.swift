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
    
    static let red                       = UIColor(hex: "#ed1c24")
    static let orange                    = UIColor(hex: "#ff7f27")
    static let yellow                    = UIColor(hex: "#fff200")
    static let green                     = UIColor(hex: "#22b14c")
    static let lightBlue                 = UIColor(hex: "#00a2e8")
    static let darkBlue                  = UIColor(hex: "#3f48cc")
    static let purple                    = UIColor(hex: "#a349a4")
}

enum UserDefault {
    static var selectedDayType           = UserDefaultsManager(key: "selectedDayType")
    static var keyboardHeight            = UserDefaultsManager(key: "keyboardHeight")
}
