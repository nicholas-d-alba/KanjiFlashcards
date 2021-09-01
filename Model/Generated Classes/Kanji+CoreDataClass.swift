//
//  Kanji+CoreDataClass.swift
//  
//
//  Created by Nicholas Alba on 7/20/21.
//
//

import Foundation
import CoreData

@objc(Kanji)
public class Kanji: NSManagedObject {
    
    class func instantiate(from kanjiCodable: KanjiCodable, withContext context: NSManagedObjectContext) -> Kanji {
        let kanji = Kanji(context: context)
        kanji.name = kanjiCodable.name
        kanji.meanings = kanjiCodable.meanings
        kanji.onReadings = kanjiCodable.onReadings
        kanji.kunReadings = kanjiCodable.kunReadings
        kanji.jlpt = Int64(kanjiCodable.jlpt)
        kanji.mastery = Int64(kanjiCodable.mastery)
        kanji.strokes = Int64(kanjiCodable.strokes)
        return kanji
    }
    
    public override var description: String {
        let on = onReadings ?? []
        let kun = kunReadings ?? []
        if let name = name, let meanings = meanings {
            return "{\(name): {meanings: \(meanings), on: \(on), kun: \(kun), strokes: \(strokes), jlpt: \(jlpt), mastery: \(mastery)}}"
        }
        return ""
    }
    
    public var isMastered: Bool {
        return Int(mastery) < 2
    }
    
}
