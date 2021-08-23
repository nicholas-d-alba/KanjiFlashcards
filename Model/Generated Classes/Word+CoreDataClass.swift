//
//  Word+CoreDataClass.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData

@objc(Word)
public class Word: NSManagedObject {

    class func instantiate(from codable: WordCodable, withContext context: NSManagedObjectContext) -> Word {
        let word = Word(context: context)
        word.kanjiSpellings = codable.kanjiSpellings
        word.priority = Int64(codable.priority)
        for readingCodable in codable.kanaReadings {
            let reading = KanaReading(context: context)
            reading.reading = readingCodable.reading
            reading.restrictions = readingCodable.restrictions.isEmpty ? nil : readingCodable.restrictions
            word.addToKanaReadings(reading)
        }
        for meaningCodable in codable.meanings {
            let meaning = Meaning(context: context)
            meaning.definitions = meaningCodable.definitions
            meaning.examples = meaningCodable.examples.isEmpty ? nil : meaningCodable.examples
            meaning.miscellaneousEntities = meaningCodable.miscellaneousEntities.isEmpty ? nil : meaningCodable.miscellaneousEntities
            meaning.order = Int64(meaningCodable.order)
            word.addToMeanings(meaning)
        }
        return word
    }
    
    override public var description: String {
        var description = "Kanji Spellings: \(kanjiSpellings!)\nReadings: \(kanaReadings!.allObjects as! [KanaReading])\nMeanings:\n"
        for meaning in meanings! as! Set<Meaning> {
            description += "\(meaning)"
        }
        description += "Priority: \(priority)\n"
        return description
    }
}
