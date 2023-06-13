//
//  Routine+CoreDataProperties.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//
//

import Foundation
import CoreData


extension Routine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Routine> {
        return NSFetchRequest<Routine>(entityName: "Routine")
    }

    @NSManaged public var ascending: Int16
    @NSManaged public var color: String?
    @NSManaged public var date: Date?
    @NSManaged public var day: Int16
    @NSManaged public var doneDate: String?
    @NSManaged public var hour: Int16
    @NSManaged public var isDone: Bool
    @NSManaged public var isFrozen: Bool
    @NSManaged public var minute: Int16
    @NSManaged public var timerSeconds: Int64
    @NSManaged public var title: String?
    @NSManaged public var uuid: String?
    @NSManaged public var logs: NSSet?
    
    public var logArray: [Log] {
        let logsSet = logs as? Set<Log> ?? []
        
        return logsSet.sorted {
            $0.unwrappedDate > $1.unwrappedDate
        }
    }

}

// MARK: Generated accessors for logs
extension Routine {

    @objc(addLogsObject:)
    @NSManaged public func addToLogs(_ value: Log)

    @objc(removeLogsObject:)
    @NSManaged public func removeFromLogs(_ value: Log)

    @objc(addLogs:)
    @NSManaged public func addToLogs(_ values: NSSet)

    @objc(removeLogs:)
    @NSManaged public func removeFromLogs(_ values: NSSet)

}

extension Routine : Identifiable {

}
