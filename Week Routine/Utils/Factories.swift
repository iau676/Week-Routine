//
//  Factories.swift
//  Week Routine
//
//  Created by ibrahim uysal on 23.04.2023.
//

import UIKit

//MARK: - UICollectionView

func makeCollectionView() -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
}

//MARK: - UILabel

func makePaddingLabel(withText text: String) -> UILabel {
    let label = UILabelPadding()
    label.textAlignment = .left
    label.numberOfLines = 0
    label.text = text
    return label
}

class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}

//MARK: - Helpers

func checkTimePassed(routine: Routine) -> Bool {
    let routineHour = routine.hour
    let routineMin = routine.minute
    
    let currentHour = Calendar.current.component(.hour, from: Date())
    let currentMin = Calendar.current.component(.minute, from: Date())
    
    let routineS = routineHour * 66 + routineMin
    let currentS = currentHour * 66 + currentMin

    return routineS > currentS
}

func getRemindHour(routine: Routine) -> String {
    let routineHour = routine.hour
    let routineMin = routine.minute
    
    let currentHour = Calendar.current.component(.hour, from: Date())
    let currentMin = Calendar.current.component(.minute, from: Date())
    
    let routineS = Int(routineHour * 60 + routineMin)
    let currentS = Int(currentHour * 60 + currentMin)
    
    let remindMin = routineS - currentS
    
    let hour = remindMin / 60
    let min = remindMin % 60
    
    let hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
    let minStr = min > 9 ? "\(min)" : "0\(min)"
    
    return "\(hourStr):\(minStr)"
}

func getTodayDate() -> String{
    return Date().getFormattedDate(format: "yyyy-MM-dd")
}

func getHour() -> Int {
    let hour = Calendar.current.component(.hour, from: Date())
    return hour
}

func getMinute() -> Int {
    let minute = Calendar.current.component(.minute, from: Date())
    return minute
}

func getDayInt() -> Int {
    //returns an integer from 1 - 7, with 1 being Sunday and 7 being Saturday -
    //1 - Sunday
    //2 - Monday
    //3 - Tuesday
    //4 - Wednesday
    //5 - Thursday
    //6 - Friday
    //7 - Saturday
    var day = Calendar.current.component(.weekday, from: Date())
    day = (day-2 < 0) ? 6 : day-2
    return day
}

func getDayName(_ dayInt: Int16) -> String {
    switch dayInt {
        case 0: return "Monday"
        case 1: return "Tuesday"
        case 2: return "Wednesday"
        case 3: return "Thursday"
        case 4: return "Friday"
        case 5: return "Saturday"
        case 6: return "Sunday"
        case 7: return "Every day"
        case 8: return "Weekday"
        case 9: return "Weekend"
        default:return ""
    }
}

func getColor(_ colorName: String) -> UIColor {
    switch colorName {
    case ColorName.red:    return Colors.red
    case ColorName.orange: return Colors.orange
    case ColorName.yellow: return Colors.yellow
    case ColorName.green:  return Colors.green
    case ColorName.blue:   return Colors.blue
    case ColorName.purple: return Colors.purple
    default:               return .label
    }
}


