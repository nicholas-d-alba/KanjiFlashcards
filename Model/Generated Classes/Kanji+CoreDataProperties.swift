//
//  Kanji+CoreDataProperties.swift
//  
//
//  Created by Nicholas Alba on 7/20/21.
//
//

import Foundation
import CoreData


extension Kanji {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kanji> {
        return NSFetchRequest<Kanji>(entityName: "Kanji")
    }

    @NSManaged public var jlpt: Int64
    @NSManaged public var kunReadings: [String]?
    @NSManaged public var mastery: Int64
    @NSManaged public var meanings: [String]?
    @NSManaged public var name: String?
    @NSManaged public var onReadings: [String]?
    @NSManaged public var strokes: Int64

}
