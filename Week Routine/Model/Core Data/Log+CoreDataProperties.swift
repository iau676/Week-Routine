//
//  Log+CoreDataProperties.swift
//  Week Routine
//
//  Created by ibrahim uysal on 30.04.2023.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var timerSeconds: Int64
    @NSManaged public var title: String?
    @NSManaged public var uuid: String?
    @NSManaged public var routine: Routine?
    
    public var unwrappedDate: Date {
        date ?? Date()
    }
}

extension Log : Identifiable {

}
