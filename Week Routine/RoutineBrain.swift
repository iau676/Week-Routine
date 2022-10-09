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
    
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func addRoutine(title: String, day: Int16, hour: Int16, minute: Int16){
        let newRoutine = Routine(context: self.context)
        newRoutine.title = title
        newRoutine.day = day
        newRoutine.hour = hour
        newRoutine.minute = minute
        newRoutine.ascending = hour * 66 + minute
        newRoutine.date = Date()
        let uuid = UUID().uuidString
        newRoutine.uuid = uuid
        self.routineArray.append(newRoutine)
        addNotification(title: title, day: Int(day), hour: Int(hour), minute: Int(minute), id: uuid)
        saveContext()
    }
    
    mutating func removeRoutine(at index: Int){
        removeNotification(id: self.routineArray[index].uuid!)
        context.delete(routineArray[index])
        routineArray.remove(at: index)
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
    
    func addNotification(title: String, day: Int, hour: Int, minute: Int, id: String){
        DispatchQueue.main.async{
            let title = title
            let message = ""
            var date = DateComponents()
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
                
            if day == 0 {
                date = DateComponents(hour: hour, minute: minute)
            } else {
                let weekday = (day+1 > 7) ? 1 : day+1
                date = DateComponents(hour: hour, minute: minute, weekday: weekday)
            }
                
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
    }
    
    func removeNotification(id: String){
        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
}
