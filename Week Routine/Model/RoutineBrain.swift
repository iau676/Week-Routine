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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Model Manupulation Methods
    
    mutating func addRoutine(title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int){
        let newRoutine = Routine(context: self.context)
        newRoutine.title = title
        newRoutine.day = Int16(day)
        newRoutine.hour = Int16(hour)
        newRoutine.minute = Int16(minute)
        newRoutine.color = color
        newRoutine.ascending = Int16(hour * 66 + minute)
        newRoutine.soundInt = Int64(soundInt)
        newRoutine.date = Date()
        newRoutine.isNotify = true
        let uuid = UUID().uuidString
        newRoutine.uuid = uuid
        self.routineArray.append(newRoutine)
        NotificationManager.shared.addNotification(title: title, dayInt: Int(day),
                                                   hour: Int(hour), minute: Int(minute),
                                                   color: color, soundInt: soundInt,
                                                   id: uuid)
        saveContext()
    }
    
    mutating func addLog(routine: Routine) {
        let newLog = Log(context: self.context)
        newLog.date = Date()
        newLog.uuid = UUID().uuidString
        newLog.title = routine.title
        
        routine.addToLogs(newLog)
        saveContext()
    }
    
    func checkCompletedToday(routine: Routine, selectedSegmentIndex: Int) -> Bool {
        if let lastLogDate = routine.logArray.first?.date {
            if brain.getDayInt() == selectedSegmentIndex && Calendar.current.isDateInToday(lastLogDate) {
                routine.isDone = true
                saveContext()
                return true
            }
        }
        routine.isDone = false
        saveContext()
        return false
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
    
    mutating func updateRoutine(routine: Routine, title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int) {
        routine.title = title
        routine.day = Int16(day)
        routine.hour = Int16(hour)
        routine.minute = Int16(minute)
        routine.color = color
        routine.ascending = Int16(hour * 66 + minute)
        routine.soundInt = Int64(soundInt)
        NotificationManager.shared.updateRoutineNotification(routine: routine)
        saveContext()
    }
    
    mutating func deleteRoutine(_ routine: Routine) {
        deleteNotification(routine: routine)
        context.delete(routine)
        saveContext()
    }
    
    func deleteNotification(routine: Routine) {
        guard let uuid = routine.uuid else { return }
        let dayInt = routine.day
        switch dayInt {
            case 8:
            NotificationManager.shared.removeNotification(id: "\(uuid)wr2")
            NotificationManager.shared.removeNotification(id: "\(uuid)wr3")
            NotificationManager.shared.removeNotification(id: "\(uuid)wr4")
            NotificationManager.shared.removeNotification(id: "\(uuid)wr5")
            NotificationManager.shared.removeNotification(id: "\(uuid)wr6")
            case 9:
            NotificationManager.shared.removeNotification(id: "\(uuid)wr7")
            NotificationManager.shared.removeNotification(id: "\(uuid)wr1")
            default:
            NotificationManager.shared.removeNotification(id: uuid)
        }
        saveContext()
    }
    
    mutating func deleteLog(_ routine: Routine, _ index: Int) {
        context.delete(routine.logArray[index])
        saveContext()
    }
    
    func updateFrozen(routine: Routine) {
        let currentFrozen = routine.isFrozen
        
        if currentFrozen {
            if let title = routine.title,
                let color = routine.color,
                let uuid = routine.uuid {
                NotificationManager.shared.addNotification(title: title, dayInt: Int(routine.day),
                                                           hour: Int(routine.hour), minute: Int(routine.minute),
                                                           color: color, soundInt: Int(routine.soundInt),
                                                           id: uuid)
            }
        } else {
            deleteNotification(routine: routine)
        }
        
        routine.isFrozen = !currentFrozen
        routine.isNotify = currentFrozen
        saveContext()
    }
    
    func updateNotification(routine: Routine) {
        let currentNotify = routine.isNotify
        
        if !currentNotify {
            if let title = routine.title,
                let color = routine.color,
                let uuid = routine.uuid {
                NotificationManager.shared.addNotification(title: title, dayInt: Int(routine.day),
                                                           hour: Int(routine.hour), minute: Int(routine.minute),
                                                           color: color, soundInt: Int(routine.soundInt),
                                                           id: uuid)
            }
        } else {
            deleteNotification(routine: routine)
        }
        
        routine.isNotify = !currentNotify
        saveContext()
    }
    
    mutating func loadRoutineArray(with request: NSFetchRequest<Routine> = Routine.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "ascending", ascending: true)]
            routineArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
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
            deleteNotification(routine: routine)
            completion(routine)
        }
    }
    
    func getTodayDate() -> String{
        return Date().getFormattedDate(format: "yyyy-MM-dd")
    }
    
    func getDayInt() -> Int {
        var day = Calendar.current.component(.weekday, from: Date())
        day = (day-2 < 0) ? 6 : day-2
        return day
    }
    
    func getHour() -> Int {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour
    }
    
    func getMinute() -> Int {
        let minute = Calendar.current.component(.minute, from: Date())
        return minute
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
