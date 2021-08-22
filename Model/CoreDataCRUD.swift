//
//  CoreDataCRUD.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/24/21.
//

import CoreData
import Foundation

class PersistentDataManager {

    // MARK: Initializers
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: Core Data Set-Up from JSON Files
    
    func setUpCoreDataIfNeeded() {
        if !UserDefaults.standard.bool(forKey: "Saved") {
            setUpKanjiIfNeeded()
            print("Kanji have been set up.")
            setUpResourcesIfNeeded()
            print("Resources have been set up.")
            UserDefaults.standard.set(true, forKey: "Saved")
        }
    }
    
    func setUpKanjiIfNeeded() {
        guard let kanjiCodables = deserializeKanjiFromJSON() else {
            print("Couldn't deserialize all Kanji from JSON file.")
            return
        }
        createAndSaveKanji(from: kanjiCodables)
    }
    
    private func setUpResourcesIfNeeded() {
        guard let resourcesCodables = deserializeKanjiResourcesFromJSON() else {
            print("Couldn't deserialize all KanjiResources from JSON file.")
            return
        }
        createAndSaveResources(from: resourcesCodables)
    }
    
    // MARK: JSON Serialization
    
    func serializeDataFromAPI() {
        guard let kanjiDataURL = URL(string: APILink),
              let kanjiData = try? Data(contentsOf: kanjiDataURL),
              let kanjiJSON = try? JSONSerialization.jsonObject(with: kanjiData, options: []),
              let dictionary = kanjiJSON as? [String:Any] else {
            print("Failed to read from Kanji JSON API.")
            return
        }
        
        var kanjiCodables:[KanjiCodable] = []
        for (name, attributes) in dictionary {
            if let attributesDictionary = attributes as? [String:Any],
               let meanings = attributesDictionary["meanings"] as? [String],
               let strokes = attributesDictionary["strokes"] as? Int,
               let jlpt = attributesDictionary["jlpt_new"] as? Int {
                let kunReadings = attributesDictionary["readings_kun"] as? [String] ?? nil
                let onReadingsInHiragana = attributesDictionary["readings_on"] as? [String] ?? nil
                var onReadingsInKatakana:[String]? = nil
                if let unwrappedOnReadingsInHiragana = onReadingsInHiragana {
                    onReadingsInKatakana = unwrappedOnReadingsInHiragana.map {katakana(for: $0)}
                }
                
                kanjiCodables.append(KanjiCodable(name: name, meanings: meanings, onReadings: onReadingsInKatakana, kunReadings: kunReadings, strokes: strokes, jlpt: jlpt, mastery: defaultMastery))
            }
        }
        
        for codable in kanjiCodables {
            do {
                let jsonData = try JSONEncoder().encode(codable)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Couldn't encode KanjiCodable instance.")
            }
        }
    }
    
    func serializeKanjiResources() {
        guard let kanjiCodables = deserializeKanjiFromJSON() else {
            print("Unable to deserialize KanjiCodables")
            return
        }
        let kanjiList = kanjiCodables.map{Kanji.instantiate(from: $0, withContext: context)}
        let allEntries = extractEntriesFromJMDictFiles()
        let wordsForKanji = findWordsForEachKanji(kanji: kanjiList, entries: allEntries)
        
        var resources:[KanjiResourcesCodable] = []
        for kanji in wordsForKanji.keys {
            guard let name = kanji.name else {
                print("Couldn't load name for kanji.")
                return
            }
            let entries = wordsForKanji[kanji]!
            let noncodableHints = findHints(forKanji: kanji, entries: entries)
            let hints = noncodableHints.map{
                HintCodable(readings: $0.readings, meanings: $0.meanings, priority: Int($0.priority))
            }
            
            var words:[WordCodable] = []
            for entry in entries {
                let kanjiSpellings = entry.kanjiElements
                let priority = entry.priority
                
                var kanaReadings:[KanaReadingCodable] = []
                for readingElement in entry.readingElements {
                    let reading = readingElement.reading
                    let restrictions = readingElement.readingRestrictions ?? []
                    let kanaReading = KanaReadingCodable(reading: reading, restrictions: restrictions)
                    kanaReadings.append(kanaReading)
                }
                
                var meanings:[MeaningCodable] = []
                for (i, senseElement) in entry.senseElements.enumerated() {
                    let definitions = senseElement.meanings
                    let examples = senseElement.examples ?? []
                    let fields = senseElement.fields ?? []
                    let miscellaneousEntities = senseElement.miscellaneousEntities ?? []
                    let order = i
                    let meaning = MeaningCodable(definitions: definitions, examples: examples, fields: fields, miscellaneousEntities: miscellaneousEntities, order: order)
                    meanings.append(meaning)
                }
                
                let word = WordCodable(kanjiSpellings: kanjiSpellings, kanaReadings: kanaReadings, meanings: meanings, priority: priority)
                words.append(word)
            }
            let resource = KanjiResourcesCodable(name: name, words: words, hints: hints)
            resources.append(resource)
        }
        
        for codable in resources {
            do {
                let jsonData = try JSONEncoder().encode(codable)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Couldn't encode KanjiResourcesCodable instance.")
            }
        }
    }
    
    // MARK: JSON Deserialization
    
    func deserializeKanjiFromJSON() -> [KanjiCodable]? {
        guard let kanjiJSONStrings = linesOfFile(named: kanjiJSONFile) else {
            print("Couldn't read lines from Kanji JSON file.")
            return nil
        }
        var kanjiCodables:[KanjiCodable] = []
        for string in kanjiJSONStrings {
            if let jsonData = string.data(using: .utf8), let kanjiCodable = try? JSONDecoder().decode(KanjiCodable.self, from: jsonData) {
                kanjiCodables.append(kanjiCodable)
            }
        }
        return kanjiCodables
    }
    
    func deserializeKanjiResourcesFromJSON() -> [KanjiResourcesCodable]? {
        guard let kanjiResourcesJSONStrings = linesOfFile(named: kanjiResourcesJSONFile) else {
            print("Couldn't read lines from KanjiResources JSON file.")
            return nil
        }
        var kanjiResourcesCodables:[KanjiResourcesCodable] = []
        for string in kanjiResourcesJSONStrings {
            if let jsonData = string.data(using: .utf8), let kanjiResourcesCodable = try? JSONDecoder().decode(KanjiResourcesCodable.self, from: jsonData) {
                kanjiResourcesCodables.append(kanjiResourcesCodable)
            }
        }
        return kanjiResourcesCodables
    }
    
    func createAndSaveKanji(from codables: [KanjiCodable]) {
        for codable in codables {
            _ = Kanji.instantiate(from: codable, withContext: context)
        }
        do {
            try context.save()
        } catch {
            print("Couldn't save all Kanji instances.")
        }
    }
    
    func createAndSaveResources(from codables: [KanjiResourcesCodable])  {
        for codable in codables {
            _ = KanjiResources.instantiate(from: codable, withContext: context)
            do {
                try context.save()
            } catch {
                print("Couldn't save all KanjiResources instances.")
            }
        }
    }
    
    // MARK: Core Data Set-Up with Progress Indicator
    
//    func setUpCoreDataIfNeeded(completion: (ProgressIndicator) -> Void) {
//        if !UserDefaults.standard.bool(forKey: "Saved") {
//            setUpKanjiIfNeeded()
//            print("Kanji have been set up.")
//            setUpResourcesIfNeeded(completion: completion)
//            print("Resources have been set up.")
//            UserDefaults.standard.set(true, forKey: "Saved")
//        }
//    }
//    
//    private func setUpResourcesIfNeeded(completion: (ProgressIndicator) -> Void) {
//        guard let resourcesCodables = deserializeKanjiResourcesFromJSON() else {
//            print("Couldn't deserialize all KanjiResources from JSON file.")
//            return
//        }
//        createAndSaveResources(from: resourcesCodables, completion: completion)
//    }
   
    func createAndSaveResource(from codable: KanjiResourcesCodable)  {
        _ = KanjiResources.instantiate(from: codable, withContext: context)
        do {
            try context.save()
        } catch {
            print("Couldn't save all KanjiResources instances.")
        }
    }
    
    func createResource(from codable: KanjiResourcesCodable) {
        _ = KanjiResources.instantiate(from: codable, withContext: context)
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("Couldn't save.")
        }
    }
    
    
    // MARK: Core Data Initial Set-Up
    
    private func populateCoreData() {
        let dataManager = PersistentDataManager(context: context)
        storeKanjiFromAPIIntoCoreData()
        let kanjiList = dataManager.loadKanji()
        let entries = extractEntriesFromJMDictFiles()
        storeKanjiResources(forKanji: kanjiList, entries: entries)
    }
    
    func storeKanjiFromAPIIntoCoreData() {
        guard let kanjiDataURL = URL(string: APILink),
              let kanjiData = try? Data(contentsOf: kanjiDataURL),
              let kanjiJSON = try? JSONSerialization.jsonObject(with: kanjiData, options: []),
              let dictionary = kanjiJSON as? [String:Any] else {
            print("Failed to read from Kanji JSON API.")
            return
        }

        for (kanjiKey, attributes) in dictionary {
            if let attributesDictionary = attributes as? [String:Any],
               let meanings = attributesDictionary["meanings"] as? [String],
               let strokes = attributesDictionary["strokes"] as? Int,
               let jlpt = attributesDictionary["jlpt_new"] as? Int {
                let kunReadings = attributesDictionary["readings_kun"] as? [String] ?? nil
                let onReadingsInHiragana = attributesDictionary["readings_on"] as? [String] ?? nil
                var onReadingsInKatakana:[String]? = nil
                if let unwrappedOnReadingsInHiragana = onReadingsInHiragana {
                    onReadingsInKatakana = unwrappedOnReadingsInHiragana.map {katakana(for: $0)}
                }

                let kanji = Kanji(context: context)
                kanji.name = kanjiKey
                kanji.meanings = meanings
                kanji.onReadings = onReadingsInKatakana
                kanji.kunReadings = kunReadings
                kanji.strokes = Int64(strokes)
                kanji.jlpt = Int64(jlpt)
                kanji.mastery = Int64(defaultMastery)
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Couldn't save all kanji.")
        }
    }
    
    private func storeKanjiResources(forKanji kanjiList: [Kanji], entries: [Entry]) {
        let wordsForKanji = findWordsForEachKanji(kanji: kanjiList, entries: entries)
        for kanji in wordsForKanji.keys {
            let words = wordsForKanji[kanji]!
            let hints = findHints(forKanji: kanji, entries: words)
            let resources = KanjiResources(context: context)
            resources.name = kanji.name
            resources.hints = hints
            
            for wordElement in words {
                let word = Word(context: context)
                word.kanjiSpellings = wordElement.kanjiElements
                word.priority = Int64(wordElement.priority)
                
                for readingElement in wordElement.readingElements {
                    let kanaReading = KanaReading(context: context)
                    kanaReading.reading = readingElement.reading
                    kanaReading.restrictions = readingElement.readingRestrictions
                    word.addToKanaReadings(kanaReading)
                }
                
                for senseElement in wordElement.senseElements {
                    let meaning = Meaning(context: context)
                    meaning.definitions = senseElement.meanings
                    meaning.examples = senseElement.examples
                    meaning.fields = senseElement.fields
                    meaning.miscellaneousEntities = senseElement.miscellaneousEntities
                    word.addToMeanings(meaning)
                }
                resources.addToWords(word)
            }
            do {
                try context.save()
            } catch {
                print("Couldn't save all kanji resources.")
            }
        }
        print("Done Saving Kanji Resources")
    }
    
    // MARK: Core Data Reading
    
    public func loadKanji() -> [Kanji] {
        do {
            let request = Kanji.fetchRequest() as NSFetchRequest<Kanji>
            return try context.fetch(request)
        } catch {
            print("Couldn't load Kanji from Core Data.")
            return []
        }
    }
    
    public func loadKanji(withJLPTLevels jlptLevels: [Int]) -> [Kanji] {
        do {
            let request = Kanji.fetchRequest() as NSFetchRequest<Kanji>
            request.predicate = NSPredicate(format: "jlpt IN %@", jlptLevels)
            return try context.fetch(request)
        } catch {
            print("Couldn't load Kanji from Core Data.")
            return []
        }
    }
    
    public func loadKanjiResources() -> [KanjiResources] {
        do {
            let request = KanjiResources.fetchRequest() as NSFetchRequest<KanjiResources>
            return try context.fetch(request)
        } catch {
            print("Couldn't load Kanji Resources from Core Data.")
            return []
        }
    }
    
    public func loadKanjiResources(forKanjiWithNames kanjiNames: [String]) -> [KanjiResources] {
        do {
            let request = KanjiResources.fetchRequest() as NSFetchRequest<KanjiResources>
            request.predicate = NSPredicate(format: "name IN %@", kanjiNames)
            return try context.fetch(request)
        } catch {
            print("Couldn't load Kanji Resources from Core Data.")
            return []
        }
    }
    
    private func linesOfFile(named filename: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
            print("Couldn't load file named \(filename)")
            return nil
        }
        do {
            let contents = try String(contentsOfFile: path)
            let lines = contents.components(separatedBy: "\n")
            return lines
        } catch {
            print("Contents could not be loaded.")
            return nil
        }
    }
    
    // MARK: Properties
    
    let context: NSManagedObjectContext
    private let defaultMastery = 4
}


private let APILink = "https://raw.githubusercontent.com/davidluzgouveia/kanji-data/master/kanji.json"
private let kanjiJSONFile = "Kanji"
private let kanjiResourcesJSONFile = "KanjiResources"
