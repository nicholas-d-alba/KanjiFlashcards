//
//  KanjiQuizzer.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/20/21.
//

import CoreData
import Foundation

struct KanjiQuiz {
    
    // MARK: Initializers
    
    init(withContext context: NSManagedObjectContext, ofLength quizLength: Int, kanji kanjiPool: [Kanji]) {
        dataManager = PersistentDataManager(context: context)
        let selectedKanji = selectKanji(quizLength, fromKanji: kanjiPool)
        retrieveResources(forKanji: selectedKanji)
    }
    
    
    // MARK: Public Methods and Computed Properties
    
    public mutating func kanjiWasRemembered() {
        let kanji = currentKanji
        if Int(kanji.mastery) > strongestMastery {
            kanji.mastery = kanji.mastery - 1
            dataManager.save()
        }
        wasKanjiRemembered.append(true)
        advanceKanji()
    }
    
    public mutating func kanjiWasForgotten() {
        let kanji = currentKanji
        if Int(kanji.mastery) < weakestMastery {
            kanji.mastery = kanji.mastery + 1
            dataManager.save()
        }
        wasKanjiRemembered.append(false)
        advanceKanji()
    }
    
    public mutating func advanceKanji() {
        index = index + 1
    }
    
    public var kanjiRemembered: [Kanji] {
        var kanjiRemembered:[Kanji] = []
        for (i, character) in kanji.enumerated() {
            if wasKanjiRemembered[i] {
                kanjiRemembered.append(character)
            }
        }
        return kanjiRemembered
    }
    
    public var kanjiForgotten: [Kanji] {
        var kanjiForgotten:[Kanji] = []
        for (i, character) in kanji.enumerated() {
            if !wasKanjiRemembered[i] {
                kanjiForgotten.append(character)
            }
        }
        return kanjiForgotten
    }
    
    public var wordsForForgottenKanji: [[Word]?] {
        var wordsForForgottenKanji:[[Word]?] = []
        for (i, wordList) in wordLists.enumerated() {
            if !wasKanjiRemembered[i] {
                wordsForForgottenKanji.append(wordList)
            }
        }
        return wordsForForgottenKanji
    }
    
    public var quizLength: Int {
        return kanji.count
    }
    
    public var isCompleted: Bool {
        return index == kanji.count
    }
    
    public var currentKanji: Kanji {
        return kanji[index]
    }
    
    public var currentHints: [Hint]? {
        return hintLists[index]
    }
    
    public var currentWords: [Word]? {
        return wordLists[index]
    }
    
    // MARK: Initializer Set-Up
    
    private func selectKanji(_ quizLength: Int, fromKanji kanjiList: [Kanji]) -> [Kanji] {
        var kanjiWithCumulativeWeights:[(weight: Int, kanji: Kanji?)] = [(0,nil)]
        for kanji in kanjiList {
            let delta = (Int(kanji.mastery)+1) * weightMultiplier
            let newWeight = kanjiWithCumulativeWeights.last!.weight + delta
            kanjiWithCumulativeWeights.append((newWeight, kanji))
        }
        var selectedKanji:[Kanji] = []
        for _ in 1...quizLength {
            let randomInt = Int.random(in: 1...kanjiWithCumulativeWeights.last!.weight)
            for i in 1..<kanjiWithCumulativeWeights.count {
                if randomInt > kanjiWithCumulativeWeights[i-1].weight && randomInt <= kanjiWithCumulativeWeights[i].weight {
                    selectedKanji.append(kanjiWithCumulativeWeights[i].kanji!)
                    break
                }
            }
        }
        return selectedKanji
    }
    
    private mutating func retrieveResources(forKanji kanjiList: [Kanji]) {
        let kanjiNames = kanjiList.map({$0.name!})
        let selectedResources = dataManager.loadKanjiResources(forKanjiWithNames: kanjiNames)
        var selectedHints: [[Hint]] = []
        var selectedWords: [[Word]] = []
        for resource in selectedResources {
            let hints = resource.hints!
            let words = resource.words!.allObjects as! [Word]
            selectedHints.append(hints.sorted(by: {$0.priority < $1.priority}))
            selectedWords.append(words.sorted(by: {$0.priority < $1.priority}))
        }
        for individualKanji in kanjiList {
            kanji.append(individualKanji)
            let index = selectedResources.firstIndex(where: {$0.name! == individualKanji.name!})
            hintLists.append(index == nil ? nil : selectedHints[index!])
            wordLists.append(index == nil ? nil : selectedWords[index!])
        }
    }
    
    // MARK: Debugging
    
    private func printQuiz() {
        print("NEW QUIZ:")
        print("\(kanji.count) kanji")
        print("\(wordLists.count) words")
        print("\(hintLists.count) hints\n")
        
        print("Selected Kanji:")
        for character in kanji {
            print(character)
        }
        print("")
        
        for i in 0..<kanji.count {
            print(kanji[i])
            guard let hintList = hintLists[i], let wordList = wordLists[i] else {
                print("MISSING HINTS OR WORDS")
                print(String(describing: hintLists[i]))
                print(String(describing: wordLists[i]))
                continue
            }
            for hint in hintList {
                print(hint)
            }
            for word in wordList {
                print(word)
            }
            print("")
        }
    }
    
    
    // MARK: Properties
    
    private let dataManager: PersistentDataManager
    private let weightMultiplier = 3
    
    var index = 0
    private var wasKanjiRemembered:[Bool] = []
    private var kanji: [Kanji] = []
    private var hintLists: [[Hint]?] = []
    private var wordLists: [[Word]?] = []
}

private let weakestMastery = 10
private let strongestMastery = 0
