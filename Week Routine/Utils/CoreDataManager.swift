//
//  CoreDataManager.swift
//  Week Routine
//
//  Created by ibrahim uysal on 6.08.2024.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func loadRoutineArray(with request: NSFetchRequest<Routine> = Routine.fetchRequest()) -> [Routine] {
        var routines = [Routine]()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "ascending", ascending: true)]
            routines = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        
        return routines
    }
    
    func addRoutine(title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int){
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
        NotificationManager.shared.addNotification(title: title, dayInt: Int(day),
                                                   hour: Int(hour), minute: Int(minute),
                                                   color: color, soundInt: soundInt,
                                                   id: uuid)
        saveContext()
    }
    
    func updateRoutine(routine: Routine, title: String, day: Int, hour: Int, minute: Int, color: String, soundInt: Int) {
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
    
    func deleteRoutine(_ routine: Routine) {
        NotificationManager.shared.deleteNotification(routine: routine)
        context.delete(routine)
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
            NotificationManager.shared.deleteNotification(routine: routine)
        }
        
        routine.isFrozen = !currentFrozen
        routine.isNotify = currentFrozen
        saveContext()
    }
    
    func checkCompletedToday(routine: Routine, selectedSegmentIndex: Int) -> Bool {
        if let lastLogDate = routine.logArray.first?.date {
            if getDayInt() == selectedSegmentIndex && Calendar.current.isDateInToday(lastLogDate) {
                routine.isDone = true
                saveContext()
                return true
            }
        }
        routine.isDone = false
        saveContext()
        return false
    }
    
    func updateNotificationOption(routine: Routine) {
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
            NotificationManager.shared.deleteNotification(routine: routine)
        }
        
        routine.isNotify = !currentNotify
        saveContext()
    }
    
    
    func addLog(routine: Routine) {
        let newLog = Log(context: self.context)
        newLog.date = Date()
        newLog.uuid = UUID().uuidString
        newLog.title = routine.title
        
        routine.addToLogs(newLog)
        saveContext()
    }
    
    func deleteLog(_ routine: Routine, _ index: Int) {
        context.delete(routine.logArray[index])
        saveContext()
    }
}
