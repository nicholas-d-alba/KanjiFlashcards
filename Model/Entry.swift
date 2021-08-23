//
//  Word.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/1/21.
//

import Foundation

public class Entry: NSObject {
    
    init(kanjiElements: [String], readingElements: [ReadingElement], senseElements: [Sense], priority: Int) {
        self.kanjiElements = kanjiElements
        self.readingElements = readingElements
        self.senseElements = senseElements
        self.priority = priority
    }
    
    func contains(kanji: Character) -> Bool {
        for kanjiElement in kanjiElements {
            if kanjiElement.contains(kanji) {
                return true
            }
        }
        return false
    }
    
    override public var description: String {
        var description = "Kanji Elements: \(kanjiElements)\nReading Elements: \(readingElements)\nSense Elements:\n"
        for sense in senseElements {
            description += sense.description
        }
        description += "Priority: \(priority)"
        return description
    }
    
    enum Key: String {
        case kanjiElements = "kanjiElements"
        case readingElements = "readingElements"
        case senseElements = "senseElements"
        case priority = "priority"
    }
    
    var kanjiElements: [String]
    var readingElements: [ReadingElement]
    var senseElements: [Sense]
    var priority: Int
}

public class ReadingElement: NSObject {
    
    init(reading: String, readingRestrictions: [String]?) {
        self.reading = reading
        self.readingRestrictions = readingRestrictions
    }
    
    override public var description: String {
        var description = reading
        if let readingRestrictions = readingRestrictions {
            description += " [\(readingRestrictions.joined(separator: ", "))]"
        }
        return description
    }
    
    enum Key: String {
        case reading = "reading"
        case readingRestrictions = "readingRestrictions"
    }
    
    var reading: String
    var readingRestrictions: [String]?
}

public class Sense: NSObject {

    init(meanings: [String], examples: [String]?, miscellaneousEntities: [String]?) {
        self.meanings = meanings
        self.examples = examples
        self.miscellaneousEntities = miscellaneousEntities
    }
    
    override public var description: String {
        var description = "Meanings: \(meanings)\n"
        if let miscellaneousEntities = miscellaneousEntities {
            description += "Misc: \(miscellaneousEntities)\n"
        }
        if let examples = examples {
            description += "Examples: \(examples)\n"
        }
        return description
    }
    
    enum Key: String {
        case meanings = "meanings"
        case examples = "examples"
        case miscellaneousEntities = "miscellaneousEntities"
    }
    
    var meanings: [String]
    var examples: [String]?
    var miscellaneousEntities: [String]?
}
