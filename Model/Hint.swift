//
//  Hint.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/22/21.
//

import Foundation

public class Hint: NSObject, NSSecureCoding {
    
    init(readings: [String], meanings: [String], priority: Int64) {
        self.readings = readings
        self.meanings = meanings
        self.priority = priority
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(readings, forKey: Key.readings.rawValue)
        coder.encode(meanings, forKey: Key.meanings.rawValue)
        coder.encode(priority, forKey: Key.priority.rawValue)
    }
    
    public required convenience init?(coder: NSCoder) {
        let decodedReadings = coder.decodeObject(of: NSArray.self, forKey: Key.readings.rawValue) as! [String]
        let decodedMeanings = coder.decodeObject(of: NSArray.self, forKey: Key.meanings.rawValue) as! [String]
        let decodedPriority = coder.decodeInt64(forKey: Key.priority.rawValue)
        self.init(readings: decodedReadings, meanings: decodedMeanings, priority: decodedPriority)
    }
    
    override public var description: String {
        "\(priority) -> \(readings.joined(separator: ", ")): \(meanings.joined(separator: ", "))"
    }
    
    enum Key: String {
        case readings = "readings"
        case meanings = "meanings"
        case priority = "priority"
    }
    
    var readings: [String]
    var meanings: [String]
    var priority: Int64
    
    public static var supportsSecureCoding = true
}

func findHints(forKanji kanji: Kanji, entries: [Entry]) -> [Hint] {
    guard let name = kanji.name else {
        return []
    }
    var hints:[Hint] = []
    for entry in entries {
        var readings:[String] = []
        for readingElement in entry.readingElements {
            let restrictions = readingElement.readingRestrictions
            if restrictions == nil || restrictions!.contains(name) {
                readings.append(readingElement.reading)
            }
        }
        if !readings.isEmpty {
            let meanings = entry.senseElements[0].meanings
            let priority = Int64(entry.priority)
            hints.append(Hint(readings: readings, meanings: meanings, priority: priority))
        }
    }
    return Array(hints.prefix(hintLimit))
}

private let hintLimit = 10
