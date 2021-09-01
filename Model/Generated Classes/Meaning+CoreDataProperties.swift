//
//  Meaning+CoreDataProperties.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData


extension Meaning {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meaning> {
        return NSFetchRequest<Meaning>(entityName: "Meaning")
    }

    @NSManaged public var definitions: [String]?
    @NSManaged public var examples: [String]?
    @NSManaged public var miscellaneousEntities: [String]?
    @NSManaged public var order: Int64
    @NSManaged public var word: Word?

}
