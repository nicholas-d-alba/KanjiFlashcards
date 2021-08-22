//
//  KanjiResourcesCodable.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/4/21.
//

import Foundation

struct KanjiResourcesCodable: Codable {
    
    var name: String
    var words: [WordCodable]
    var hints: [HintCodable]
}

struct WordCodable: Codable {
    
    var kanjiSpellings: [String]
    var kanaReadings: [KanaReadingCodable]
    var meanings: [MeaningCodable]
    var priority: Int
}

struct KanaReadingCodable: Codable {
    
    var reading: String
    var restrictions: [String]
}

struct MeaningCodable: Codable {
    
    var definitions: [String]
    var examples: [String]
    var fields: [String]
    var miscellaneousEntities: [String]
    var order: Int
}


struct HintCodable: Codable {
    
    var readings: [String]
    var meanings: [String]
    var priority: Int
}


