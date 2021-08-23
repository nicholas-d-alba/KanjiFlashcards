//
//  KanaReading+CoreDataClass.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData

@objc(KanaReading)
public class KanaReading: NSManagedObject {
    
    override public var description: String {
        var description = reading!
        if let restrictions = restrictions {
            description += " [\(restrictions.joined(separator: ", "))]"
        }
        return description
    }
    
}
