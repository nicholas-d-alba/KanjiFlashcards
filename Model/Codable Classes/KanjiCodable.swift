//
//  KanjiCodable.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/4/21.
//

import Foundation

struct KanjiCodable: Codable {

    var name: String
    var meanings: [String]
    var onReadings: [String]?
    var kunReadings: [String]?
    var strokes: Int
    var jlpt: Int
    var mastery: Int
}

//kanji.name = kanjiKey
//kanji.meanings = meanings
//kanji.onReadings = onReadingsInKatakana
//kanji.kunReadings = kunReadings
//kanji.strokes = Int64(strokes)
//kanji.jlpt = Int64(jlpt)
//kanji.mastery = Int64(defaultMastery)
