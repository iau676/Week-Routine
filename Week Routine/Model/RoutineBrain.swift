//
//  RoutineBrain.swift
//  Week Routine
//
//  Created by ibrahim uysal on 7.10.2022.
//

import UIKit
import CoreData

struct RoutineBrain {
    
    var routineArray = [Routine]()
    static var shareInstance = RoutineBrain()
    
    var days = [["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                ["I", "II", "III", "IV", "V", "VI", "VII"],
                ["1", "2", "3", "4", "5", "6", "7"]]
    
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Model Manupulation Methods
    
    mutating func addRoutine(title: String, day: Int, hour: Int, minute: Int, color: String, timerHour: Int, timerMin: Int, timerSec: Int){
        let newRoutine = Routine(context: self.context)
        newRoutine.title = title
        newRoutine.day = Int16(day)
        newRoutine.hour = Int16(hour)
        newRoutine.minute = Int16(minute)
        newRoutine.color = color
        newRoutine.ascending = Int16(hour * 66 + minute)
        newRoutine.timerSeconds = Int64((timerHour * 3600) + (timerMin * 60) + timerSec)
        newRoutine.date = Date()
        let uuid = UUID().uuidString
        newRoutine.uuid = uuid
        self.routineArray.append(newRoutine)
        addNotification(title: title, dayInt: Int(day), hour: Int(hour), minute: Int(minute), color: color, id: uuid)
        saveContext()
    }
    
    mutating func addLog(routine: Routine, content: String) {
        let newLog = Log(context: self.context)
        newLog.date = Date()
        newLog.uuid = UUID().uuidString
        newLog.title = routine.title
        newLog.content = content
        
        routine.addToLogs(newLog)
        saveContext()
    }
    
    mutating func updateRoutine(routine: Routine, title: String, day: Int, hour: Int, minute: Int, color: String, timerHour: Int, timerMin: Int, timerSec: Int) {
        routine.title = title
        routine.day = Int16(day)
        routine.hour = Int16(hour)
        routine.minute = Int16(minute)
        routine.color = color
        routine.ascending = Int16(hour * 66 + minute)
        routine.timerSeconds = Int64((timerHour * 3600) + (timerMin * 60) + timerSec)
        updateRoutineNotification(routine: routine)
        saveContext()
    }
    
    mutating func deleteRoutine(_ routine: Routine) {
        guard let uuid = routine.uuid else { return }
        let dayInt = routine.day
        switch dayInt {
            case 8:
                removeNotification(id: "\(uuid)wr2")
                removeNotification(id: "\(uuid)wr3")
                removeNotification(id: "\(uuid)wr4")
                removeNotification(id: "\(uuid)wr5")
                removeNotification(id: "\(uuid)wr6")
            case 9:
                removeNotification(id: "\(uuid)wr7")
                removeNotification(id: "\(uuid)wr1")
            default:
                removeNotification(id: uuid)
        }
        context.delete(routine)
        saveContext()
    }
    
    mutating func deleteLog(_ routine: Routine, _ index: Int) {
        context.delete(routine.logArray[index])
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
    
    func updateRoutineState(routine: Routine) {
        if routine.isDone {
            routine.isDone = false
            routine.doneDate = ""
        } else {
            routine.isDone = true
            routine.doneDate = getTodayDate()
        }
        brain.saveContext()
    }
    
    func getTimerString(for second: Int) -> String {
        let totalSeconds = second
        var str = totalSeconds > 0 ? "- " : ""
    
        let hour = totalSeconds / 3600
        let min = (totalSeconds - (hour*3600)) / 60
        let sec = totalSeconds - ((hour*3600)+(min*60))
    
        let hStr = hour > 0 ? "\(hours[Int(hour)])\'" : ""
        let mStr = min > 0 ? "\(minutes[Int(min)])\"" : ""
        let sStr = sec > 0 ? "\(seconds[Int(sec)])" : ""

        str.append(hStr)
        str.append(mStr)
        str.append(sStr)
        return str
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
    
    func getColorEmoji(_ colorName: String) -> String {
        switch colorName {
        case ColorName.red:    return "🔴 "
        case ColorName.orange: return "🟠 "
        case ColorName.yellow: return "🟡 "
        case ColorName.green:  return "🟢 "
        case ColorName.blue:   return "🔵 "
        case ColorName.purple: return "🟣 "
        default:               return ""
        }
    }
    
    //MARK: - Notification
    
    func askNotificationPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
    }
    
    func addNotification(title: String, dayInt: Int, hour: Int, minute: Int, color: String, id: String){
        DispatchQueue.main.async{
            let emoji = getColorEmoji(color)
            let title = "\(emoji)\(title)"
            let message = ""
            var date = DateComponents()

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.sound = UNNotificationSound.default
            
            switch dayInt {
                case 7:
                    date = DateComponents(hour: hour, minute: minute)
                    addNotificationCenter(date: date, content: content, id: id)
                break
                case 8:
                    for i in 2...6 {
                        date = DateComponents(hour: hour, minute: minute, weekday: i)
                        addNotificationCenter(date: date, content: content, id: "\(id)wr\(i)")
                    }
                break
                case 9:
                    date = DateComponents(hour: hour, minute: minute, weekday: 7)
                    addNotificationCenter(date: date, content: content, id: "\(id)wr7")
                    date = DateComponents(hour: hour, minute: minute, weekday: 1)
                    addNotificationCenter(date: date, content: content, id: "\(id)wr1")
                break
                default:
                    let weekday = (dayInt+2 > 7) ? 1 : dayInt+2
                    date = DateComponents(hour: hour, minute: minute, weekday: weekday)
                    addNotificationCenter(date: date, content: content, id: id)
                break
            }
        }
    }
    
    func addNotificationCenter(date: DateComponents, content: UNMutableNotificationContent, id: String){
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let id = id
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
        self.notificationCenter.add(request) { (error) in
            if(error != nil){
                print("Error " + error.debugDescription)
                return
            }
        }
    }
    
    func removeNotification(id: String){
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func updateRoutineNotification(routine: Routine){
        guard let title = routine.title else{return}
        guard let uuid = routine.uuid else{return}
        
        removeNotification(id: uuid)
        addNotification(title: title, dayInt: Int(routine.day), hour: Int(routine.hour), minute: Int(routine.minute), color: routine.color ?? "", id: uuid)
    }
}
