//
//  KanaReading+CoreDataProperties.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData


extension KanaReading {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<KanaReading> {
        return NSFetchRequest<KanaReading>(entityName: "KanaReading")
    }

    @NSManaged public var reading: String?
    @NSManaged public var restrictions: [String]?
    @NSManaged public var word: Word?

}
