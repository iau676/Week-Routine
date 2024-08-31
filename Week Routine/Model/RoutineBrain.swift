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
    private init() {}
    
    var routineArray = [Routine]()
    
    mutating func loadRoutineArray(with request: NSFetchRequest<Routine> = Routine.fetchRequest()){
        routineArray = CoreDataManager.shared.loadRoutineArray()
    }
    
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
    
    mutating func checkCompletedToday(routine: Routine, selectedSegmentIndex: Int) -> Bool {
        let result = CoreDataManager.shared.checkCompletedToday(routine: routine, selectedSegmentIndex: selectedSegmentIndex)
        return result
    }
    
    mutating func updateFrozen(routine: Routine) {
        CoreDataManager.shared.updateFrozen(routine: routine)
    }
        
    func findRoutines(for selectedSegmentIndex: Int) -> [Int] {
        var tempArray = [Int]()
        let array = brain.routineArray
        
        for i in 0..<array.count {
            let routine = array[i]
            if !routine.isFrozen {
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
        }
        return tempArray
    }
    
    func findFrozenRoutines() -> [Int] {
        var tempArray = [Int]()
        let array = brain.routineArray
        
        for i in 0..<array.count {
            let routine = array[i]
            if routine.isFrozen { tempArray.append(i) }
        }
        return tempArray
    }
}
