//
//  Word+CoreDataProperties.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData


extension Word {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Word> {
        return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var kanjiSpellings: [String]?
    @NSManaged public var priority: Int64
    @NSManaged public var kanjiResources: KanjiResources?
    @NSManaged public var kanaReadings: NSSet?
    @NSManaged public var meanings: NSSet?

}

// MARK: Generated accessors for kanaReadings
extension Word {

    @objc(addKanaReadingsObject:)
    @NSManaged public func addToKanaReadings(_ value: KanaReading)

    @objc(removeKanaReadingsObject:)
    @NSManaged public func removeFromKanaReadings(_ value: KanaReading)

    @objc(addKanaReadings:)
    @NSManaged public func addToKanaReadings(_ values: NSSet)

    @objc(removeKanaReadings:)
    @NSManaged public func removeFromKanaReadings(_ values: NSSet)

}

// MARK: Generated accessors for meanings
extension Word {

    @objc(addMeaningsObject:)
    @NSManaged public func addToMeanings(_ value: Meaning)

    @objc(removeMeaningsObject:)
    @NSManaged public func removeFromMeanings(_ value: Meaning)

    @objc(addMeanings:)
    @NSManaged public func addToMeanings(_ values: NSSet)

    @objc(removeMeanings:)
    @NSManaged public func removeFromMeanings(_ values: NSSet)

}
