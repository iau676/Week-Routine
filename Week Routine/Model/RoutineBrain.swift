//
//  RoutineBrain.swift
//  Week Routine
//
//  Created by ibrahim uysal on 7.10.2022.
//

import UIKit
import CoreData

struct RoutineBrain {
    
    static var shareInstance = RoutineBrain()
    
    var routineArray = [Routine]()
    
    //MARK: - Model Manupulation Methods
    
    mutating func addRoutine(title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int){
        CoreDataManager.shared.addRoutine(title: title, day: day, hour: hour, minute: minute, color: color, soundInt: soundInt)
    }
    
    mutating func updateRoutine(routine: Routine, title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int) {
        CoreDataManager.shared.updateRoutine(routine: routine, title: title, day: day, hour: hour, minute: minute, color: color, soundInt: soundInt)
    }
    
    mutating func deleteRoutine(_ routine: Routine) {
        CoreDataManager.shared.deleteRoutine(routine)
    }
    
    mutating func addLog(routine: Routine) {
        CoreDataManager.shared.addLog(routine: routine)
    }
    
    mutating func deleteLog(_ routine: Routine, _ index: Int) {
        CoreDataManager.shared.deleteLog(routine, index)
    }
    
    mutating func loadRoutineArray(with request: NSFetchRequest<Routine> = Routine.fetchRequest()){
        routineArray = CoreDataManager.shared.loadRoutineArray()
    }
    
    //MARK: - Freeze
    
    mutating func updateFrozen(routine: Routine) {
        CoreDataManager.shared.updateFrozen(routine: routine)
    }
    
    //MARK: - Helpers
    
    func findRoutines(for selectedSegmentIndex: Int) -> [Int] {
        var tempArray = [Int]()
        let array = brain.routineArray
        
        for i in 0..<array.count {
            let routine = array[i]
            switch selectedSegmentIndex {
            case 0: if routine.day == 0 || routine.day == 7 || routine.day == 8 { tempArray.append(i) }
            case 1: if routine.day == 1 || routine.day == 7 || routine.day == 8 { tempArray.append(i) }
            case 2: if routine.day == 2 || routine.day == 7 || routine.day == 8 { tempArray.append(i) }
            case 3: if routine.day == 3 || routine.day == 7 || routine.day == 8 { tempArray.append(i) }
            case 4: if routine.day == 4 || routine.day == 7 || routine.day == 8 { tempArray.append(i) }
            case 5: if routine.day == 5 || routine.day == 7 || routine.day == 9 { tempArray.append(i) }
            case 6: if routine.day == 6 || routine.day == 7 || routine.day == 9 { tempArray.append(i) }
            default: break
            }
        }
        return tempArray
    }
    
    mutating func findRoutine(uuid: String, completion: (Routine)-> Void) {
        loadRoutineArray()
        if let routine = routineArray.first(where: {$0.uuid == uuid}) {
            NotificationManager.shared.deleteNotification(routine: routine)
            completion(routine)
        }
    }
    
    mutating func checkCompletedToday(routine: Routine, selectedSegmentIndex: Int) -> Bool {
        let result = CoreDataManager.shared.checkCompletedToday(routine: routine, selectedSegmentIndex: selectedSegmentIndex)
        return result
    }
    
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
 
}
