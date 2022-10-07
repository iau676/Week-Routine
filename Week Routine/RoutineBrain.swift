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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func addRoutine(title: String, day: Int16, hour: Int16, minute: Int16){
        let newRoutine = Routine(context: self.context)
        newRoutine.title = title
        newRoutine.day = day
        newRoutine.hour = hour
        newRoutine.minute = minute
        newRoutine.ascending = hour * 66 + minute
        newRoutine.date = Date()
        newRoutine.uuid = UUID().uuidString
        self.routineArray.append(newRoutine)
        saveContext()
    }
    
    mutating func removeRoutine(at index: Int){
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
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
}
