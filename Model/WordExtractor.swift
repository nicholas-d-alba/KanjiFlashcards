//
//  WordExtractor.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/3/21.
//

import Foundation
import SwiftyXMLParser

// Creates Entry instance from an entry element in the JMdict_E file.
// Returns nil if the entry does not contain kanji.
// Each entry is guaranteed to contain at least one reading element
//   and one sense element by the authors of the xml file.

func extractDetailsForEntryContainingKanji(forEntry entry: XML.Accessor) -> Entry? {
    guard let kanjiElements = allKanjiElements(forEntry: entry),
          let readingElements = allReadingElements(forEntry: entry),
          let senseElements = allSenseObjects(forEntry: entry) else {
        return nil
    }
    if let priority = priority(forEntry: entry) {
        return Entry(kanjiElements: kanjiElements, readingElements: readingElements, senseElements: senseElements, priority: priority)
    } else {
        return Entry(kanjiElements: kanjiElements, readingElements: readingElements, senseElements: senseElements, priority: 99)
    }

}

func isCommon(_ entry: XML.Accessor) -> Bool {
    for kanjiElement in entry["k_ele"] {
        for priority in kanjiElement["ke_pri"] {
            if let text = priority.text, text.hasPrefix("nf") {
                return true
            }
        }
    }
    return false
}

func allKanjiElements(forEntry entry: XML.Accessor) -> [String]? {
    var elements:[String] = []
    for k_ele in entry["k_ele"] {
        for keb in k_ele["keb"] {
            if let text = keb.text {
                elements.append(text)
            }
        }
    }
    return elements.isEmpty ? nil : elements
}

func allReadingElements(forEntry entry: XML.Accessor) -> [ReadingElement]? {
    var elements:[ReadingElement] = []
    for r_ele in entry["r_ele"] {
        var reading: String = ""
        var restrictions: [String] = []
        if let text = r_ele["reb"].text {
            reading = text
        }
        for re_restr in r_ele["re_restr"] {
            if let restrictionText = re_restr.text {
                restrictions.append(restrictionText)
            }
        }
        if !reading.isEmpty {
            let readingRestrictions = restrictions.isEmpty ? nil : restrictions
            let readingElement = ReadingElement(reading: reading, readingRestrictions: readingRestrictions)
            elements.append(readingElement)
        }
    }
    return elements.isEmpty ? nil : elements
}

func priority(forEntry entry: XML.Accessor) -> Int? {
    for kanjiElement in entry["k_ele"] {
        for priority in kanjiElement["ke_pri"] {
            if let text = priority.text, text.hasPrefix("nf") {
                let startIndex = text.index(text.startIndex, offsetBy: 2)
                let endIndex = text.endIndex
                let priorityDigits = text[startIndex..<endIndex]
                return Int(String(priorityDigits))!
            }
        }
    }
    return nil
}

func allSenseObjects(forEntry entry: XML.Accessor) -> [Sense]? {
    var senseStructs:[Sense] = []
    for sense in entry["sense"] {
        let meanings = allMeanings(forSense: sense)
        let examples = allExamples(forSense: sense)
        let fields = allFields(forSense: sense)
        let misc = allMiscellaneousEntities(forSense: sense)
        let senseStruct = Sense(meanings: meanings, examples: examples, fields: fields, miscellaneousEntities: misc)
        senseStructs.append(senseStruct)
    }
    return senseStructs.isEmpty ? nil : senseStructs
}

func allMeanings(forSense sense: XML.Accessor) -> [String] {
    var meaningSet:[String] = []
    for gloss in sense["gloss"] {
        if let text = gloss.text {
            meaningSet.append(text)
        }
    }
    return meaningSet
}

func allExamples(forSense sense: XML.Accessor) -> [String]? {
    var examples:[String] = []
    for example in sense["example"]["ex_sent"] {
        if let text = example.text {
            examples.append(text)
        }
    }
    return examples.isEmpty ? nil : examples
}

func allFields(forSense sense: XML.Accessor) -> [String]? {
    var fields:[String] = []
    for fieldLabel in sense["field"] {
        if let text = fieldLabel.text {
            let field = fieldMap[text]
            fields.append(field!)
        }
    }
    return fields.isEmpty ? nil : fields
}

func allMiscellaneousEntities(forSense sense: XML.Accessor) -> [String]? {
    var entities:[String] = []
    for entityLabel in sense["misc"] {
        if let text = entityLabel.text {
            let entity = miscellaneousEntitiesMap[text]
            entities.append(entity!)
        }
    }
    return entities.isEmpty ? nil : entities
}


let fieldMap:[String:String] = [
    "agric":"agriculture", "anat":"Anatomy", "archeol":"Archeology", "archit":"Architecture", "art":"Art, Aesthetics", "astron":"Astronomy", "audvid":"Audiovisual", "aviat":"Aviation", "baseb":"Baseball", "biochem":"Biochemistry", "biol":"Biology", "bot":"Botany", "Buddh":"Buddhism", "bus":"Business", "chem":"Chemistry", "Christn":"Christianity", "cloth":"Clothing", "comp":"Computing", "cryst":"Crystallography", "ecol":"Ecology", "econ":"Economics", "elec":"Electricity, Electrical Engineering", "electr":"Electronics", "embryo":"Embryology", "engr":"Engineering", "ent":"Entomology", "finc":"Finance", "fish":"Fishing", "food":"Food, Cooking", "gardn":"Gardening, Horticulture", "genet":"Genetics", "geogr":"Geography", "geol":"Geology", "geom":"Geometry", "go": "Go (game)", "golf":"Golf", "gramm":"Grammar", "grmyth":"Greek Mythology", "hanaf":"Hanafuda", "horse":"Horse Racing", "law":"Law", "ling":"Linguistics", "logic":"Logic", "MA":"Martial Arts", "mahj":"Mahjong", "math":"Mathematics", "mech":"Mechanical Engineering", "med":"Medicine", "met":"Meteorology", "mil":"Military", "music":"Music", "ornith":"Ornithology", "paleo":"Paleonthology", "pathol":"Pathology", "pharm":"Pharmacy", "phil":"Philosophy", "photo":"Photography", "physics":"Physics", "physiol":"Physiology", "print":"Printing", "psy":"Psychiatry", "psych":"Psychology", "rail":"Railway", "Shinto":"Shinto", "shogi":"Shogi", "sports":"Sports", "stat":"Statistics", "sumo":"Sumo", "telec":"Telecommunications", "tradem":"Trademark", "vidg":"Video Games", "zool":"Zoology"
]
 
let miscellaneousEntitiesMap = [
    "abbr":"abbreviation", "arch":"archaism", "char":"character", "chn":"children's language", "col":"colloquialism", "company":"company name", "creat":"creature", "dated":"dated term", "dei":"deity", "derog":"derogatory", "doc":"document", "ev":"event", "fam":"familiar language", "fem":"female term or language", "fict":"fiction", "form":"formal or literary term", "given":"given name or forename, gender not specified", "group":"group", "hist":"historical term", "hon":"honorific or respectful (sonkeigo) language", "hum":"humble (kenjougo) language", "id":"idiomatic expression", "joc":"jocular, humorous term", "leg":"legend", "m-sl":"manga slang", "male":"male term or language", "myth":"mythology", "net-sl":"internet slang", "obj":"object", "obs":"obsolete term", "obsc":"obscure term", "on-mim":"onomatopoeic or mimetic word", "organization":"organization name", "oth":"other", "person":"full name of a particular person", "place":"place name", "poet":"poetical term", "pol":"polite (teineigo) language", "product":"product name", "proverb":"proverb", "quote":"quotation", "rare":"rare", "relig":"religion", "sens":"sensitive", "serv":"service", "sl":"slang", "station":"railway station", "surname":"family or surname", "uk":"word usually written with kana alone", "unclass":"unclassified name", "vulg":"vulgar expression or word", "work":"name of a work of art, literature, music, etc.", "X":"rude or X-rated term (not displayed in educational software)", "yoji":"yojijukugo"
]
