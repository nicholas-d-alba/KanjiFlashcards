//
//  JMDictReader.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/6/21.
//

import Foundation
import SwiftyXMLParser

func extractEntriesFromJMDictFiles() -> [Entry] {
    return extractEntriesFromJMDictFiles(startFile: 1, endFile: 20)
}

private func extractEntriesFromJMDictFiles(startFile: Int, endFile: Int) -> [Entry] {
    var entries:[Entry] = []
    for i in startFile...endFile {
        readFile(named: "Dictionary Output File \(i)", entries: &entries)
        print(entries.count)
    }
    entries.sort {$0.priority < $1.priority}
    return entries
}

// Appends common entries from the requested file onto the entries array.

func readFile(named filename: String, entries: inout [Entry]) {
    guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
        print("Couldn't load file named \(filename)")
        return
    }
    do {
        let contents = try String(contentsOfFile: path)
        guard let xml = try? XML.parse(contents) else {
            print("Couldn't parse string contents of \(filename) into xml.")
            return
        }
        for entryXML in xml["JMdict"]["entry"] {
            if let entry = extractDetailsForEntryContainingKanji(forEntry: entryXML) {
                entries.append(entry)
            }
        }
    } catch {
        print("Contents of \(filename) could not be loaded.")
    }
}

func findWordsForEachKanji(kanji: [Kanji], entries: [Entry]) -> [Kanji:[Entry]] {
    var wordsForKanji:[Kanji:[Entry]] = [:]
    for kanji in kanji {
        guard let name = kanji.name else {
            return [:]
        }
        var wordsContainingKanji:[Entry] = []
        for entry in entries {
            if entry.contains(kanji: Character(name)) {
                wordsContainingKanji.append(entry)
            }
        }
        wordsContainingKanji.sort {$0.priority < $1.priority}
        wordsContainingKanji = Array(wordsContainingKanji.prefix(wordLimit))
        if !wordsContainingKanji.isEmpty {
            wordsForKanji[kanji] = wordsContainingKanji
        } else {
            print(String(describing: kanji.name))
        }
        print(wordsForKanji.count)
    }
    return wordsForKanji
}

private let wordLimit = 20
