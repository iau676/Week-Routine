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
    static let placeholderColor          = UIColor(named: "placeholderColor")
    static let blackColor                = UIColor(hex: "#1C1C1E")
    
    static let red                       = UIColor.systemRed
    static let orange                    = UIColor.systemOrange
    static let yellow                    = UIColor.systemYellow
    static let green                     = UIColor.systemGreen
    static let blue                      = UIColor.systemBlue
    static let purple                    = UIColor.systemPurple
}

enum ColorName {
    static let defaultt                  = "default"
    static let red                       = "red"
    static let orange                    = "orange"
    static let yellow                    = "yellow"
    static let green                     = "green"
    static let blue                      = "blue"
    static let purple                    = "purple"
}

enum UserDefault {
    static var selectedDayType           = UserDefaultsManager(key: "selectedDayType")
    static var keyboardHeight            = UserDefaultsManager(key: "keyboardHeight")
}

enum Images {
    static let cross                     = UIImage(named: "cross")
    static let bin                       = UIImage(named: "bin")
    static let edit                      = UIImage(named: "edit")
    static let routine                   = UIImage(named: "routine")
}
