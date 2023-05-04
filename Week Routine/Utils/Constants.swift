//
//  Constants.swift
//  Week Routine
//
//  Created by ibrahim uysal on 8.10.2022.
//

import UIKit

var brain = RoutineBrain.shareInstance

let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Every day", "Weekday", "Weekend"]

let hours = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]

let minutes = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]

let colors: [UIColor] = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow,
                         UIColor.systemGreen, UIColor.systemBlue, UIColor.systemPurple]

let colorNames: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "default"]

enum Colors {
    static let darkBackground            = UIColor(white: 0.1, alpha: 0.7)
    static let backgroundColor           = UIColor(named: "backgroundColor")
    static let viewColor                 = UIColor(named: "viewColor")
    static let labelColor                = UIColor(named: "labelColor")
    static let placeholderColor          = UIColor(named: "placeholderColor")
    static let flashColor                = UIColor(named: "flashColor")
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

enum UDM {
    static var selectedDayType           = UserDefaultsManager(key: "selectedDayType")
}

enum Images {
    static let cross                     = UIImage(named: "cross")
    static let bin                       = UIImage(named: "bin")
    static let edit                      = UIImage(named: "edit")
    static let menu                      = UIImage(named: "menu")
    static let routine                   = UIImage(named: "routine")
    
    static let history                   = UIImage(named: "history")
    static let dots                      = UIImage(named: "dots")
}

enum Fonts {
    static let AvenirNextRegular         = "AvenirNext-Regular"
    static var AvenirNextDemiBold        = "AvenirNext-DemiBold"
    static var AvenirNextMedium          = "AvenirNext-Medium"
}
