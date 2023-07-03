//
//  Constants.swift
//  Week Routine
//
//  Created by ibrahim uysal on 8.10.2022.
//

import UIKit

var brain = RoutineBrain.shareInstance

let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "Every day", "Weekday", "Weekend"]

let hours = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]

let minutesWithZero = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]

let minutesWithoutZero = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]

let colors: [UIColor] = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow,
                         UIColor.systemGreen, UIColor.systemBlue, UIColor.systemPurple]

let colorNames: [String] = ["red", "orange", "yellow", "green", "blue", "purple", "default"]

let sounds: [String] = ["Default", "Divinity", "Piouh", "Train", "Cardinal", "Multiverse", "None"]

enum Colors {
    static let darkBackground            = UIColor(white: 0.1, alpha: 0.7)
    static let backgroundColor           = UIColor(named: "backgroundColor")
    static let viewColor                 = UIColor(named: "viewColor")
    static let labelColor                = UIColor(named: "labelColor")
    static let placeholderColor          = UIColor(named: "placeholderColor")
    static let flashColor                = UIColor(named: "flashColor")
    static let blackColor                = UIColor(hex: "#1C1C1E")
    static let iceColor                  = UIColor(hex: "#66cdfe") ?? .systemBlue
    
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
    static var version12                 = UserDefaultsManager(key: "version12")
    static var currentNotificationDate   = UserDefaultsManager(key: "currentNotificationDate")
    static var routineUUID               = UserDefaultsManager(key: "routineUUID")
    static var lastTimerCounter          = UserDefaultsManager(key: "lastTimerCounter")
    static var isTimerCompleted          = UserDefaultsManager(key: "isTimerCompleted")
}

enum Images {
    static let cross                     = UIImage(named: "cross")
    static let bin                       = UIImage(named: "bin")
    static let edit                      = UIImage(named: "edit")
    static let menu                      = UIImage(named: "menu")
    static let routine                   = UIImage(named: "routine")
    
    static let history                   = UIImage(named: "history")
    static let dots                      = UIImage(named: "dots")
    static let next                      = UIImage(named: "next")
    
    static let snowflake                 = UIImage(named: "snowflake")
    static let notification              = UIImage(named: "notification")
    static let plus                      = UIImage(named: "plus")
}

enum Fonts {
    static let AvenirNextRegular         = "AvenirNext-Regular"
    static var AvenirNextDemiBold        = "AvenirNext-DemiBold"
    static var AvenirNextMedium          = "AvenirNext-Medium"
}
