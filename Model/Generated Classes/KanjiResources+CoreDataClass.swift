//
//  KanjiResources+CoreDataClass.swift
//  
//
//  Created by Nicholas Alba on 7/22/21.
//
//

import Foundation
import CoreData

@objc(KanjiResources)
public class KanjiResources: NSManagedObject {
    
    class func instantiate(from codable: KanjiResourcesCodable, withContext context: NSManagedObjectContext) -> KanjiResources {
        let kanjiResources = KanjiResources(context: context)
        kanjiResources.name = codable.name
        kanjiResources.hints = codable.hints.map {
            Hint(readings: $0.readings, meanings: $0.meanings, priority: Int64($0.priority))
        }
        for wordCodable in codable.words {
            let word = Word.instantiate(from: wordCodable, withContext: context)
            kanjiResources.addToWords(word)
        }
        return kanjiResources
    }
    
    func print() {
        Swift.print("KANJI:\(name!)\n\nHints:")
        let hints = hints!.sorted {$0.priority < $1.priority}
        for hint in hints {
            Swift.print(hint)
        }
        Swift.print("\nWords:\n")
        let words = words!.allObjects as! [Word]
        for word in words.sorted(by: {$0.priority < $1.priority}) {
            Swift.print(word)
        }
        Swift.print("\n\n\n")
    }
    
}
