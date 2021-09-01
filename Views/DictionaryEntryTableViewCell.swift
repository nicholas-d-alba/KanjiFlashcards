//
//  DictionaryEntryTableViewCell.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/3/21.
//

import UIKit

class DictionaryEntryTableViewCell: UITableViewCell {

    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Set-Up
    
    func setColors(forViewController viewController: UIViewController) {
        contentView.backgroundColor = viewController.contentBackgroundColor
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = viewController.borderColor.cgColor
        
        spellingsStackView.subviews.forEach {
            $0.subviews.forEach {
                if let label = $0 as? UILabel {
                    label.textColor = viewController.textColor
                }
            }
        }
        
        meaningsStackView.subviews.forEach {
            $0.subviews.forEach {
                if let label = $0 as? UILabel {
                    label.textColor = viewController.textColor
                }
                $0.subviews.forEach {
                    if let label = $0 as? UILabel {
                        label.textColor = viewController.textColor
                    }
                }
            }
        }
    }
    
    private func setUpUI() {
        contentView.addSubview(spellingsStackView)
        contentView.addSubview(meaningsStackView)
        
        NSLayoutConstraint.activate([
            spellingsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            spellingsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            spellingsStackView.bottomAnchor.constraint(equalTo: meaningsStackView.topAnchor, constant: -4),
            spellingsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            meaningsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            meaningsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            meaningsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func loadDetails(forWord word: Word) {
        guard let spellingsArray = word.kanjiSpellings, let readingsArray = word.kanaReadings?.allObjects as? [KanaReading], let meanings = word.meanings?.allObjects as? [Meaning] else {
            return
        }
        
        spellingsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        meaningsStackView.arrangedSubviews.forEach {$0.removeFromSuperview()}
        
        loadSpellingsAndReadings(spellingsArray: spellingsArray, readingsArray: readingsArray)
        loadMeanings(meanings: meanings)
    }
    
    private func loadSpellingsAndReadings(spellingsArray: [String], readingsArray: [KanaReading]) {
        var containers:[UIView] = []
        var prefixLabels:[UILabel] = []
        var suffixLabels:[UILabel] = []
        
        for spelling in spellingsArray {
            prefixLabels.append(prefixLabel(forSpelling: spelling))
        }
        prefixLabels.sort{$0.intrinsicContentSize.width < $1.intrinsicContentSize.width}
        guard let maxWidthAnchor = prefixLabels.last?.widthAnchor else {return}
        
        for prefixLabel in prefixLabels {
            guard let text = prefixLabel.text else {return}
            let spelling = text.components(separatedBy: ":")[0]
            var associatedReadings:[String] = []
            let relevantReadings = readingsArray.filter {
                $0.restrictions == nil || $0.restrictions!.contains(spelling)
            }
            for reading in relevantReadings {
                if let unwrappedReading = reading.reading {
                    associatedReadings.append(unwrappedReading)
                }
            }
            
            let (containerView, _, suffixLabel) = spellingAndReadingView(forSpellingLabel: prefixLabel, associatedReadings: associatedReadings)
            containers.append(containerView)
            suffixLabels.append(suffixLabel)
            spellingsStackView.addArrangedSubview(containerView)
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: spellingsStackView.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: spellingsStackView.trailingAnchor)
            ])
        }
        
        for i in 0..<containers.count {
            NSLayoutConstraint.activate([
                prefixLabels[i].topAnchor.constraint(equalTo: containers[i].topAnchor),
                prefixLabels[i].leadingAnchor.constraint(equalTo: containers[i].leadingAnchor),
                prefixLabels[i].widthAnchor.constraint(equalTo: maxWidthAnchor),
                suffixLabels[i].leadingAnchor.constraint(equalTo: prefixLabels[i].trailingAnchor),
                suffixLabels[i].firstBaselineAnchor.constraint(equalTo: prefixLabels[i].firstBaselineAnchor),
                suffixLabels[i].bottomAnchor.constraint(equalTo: containers[i].bottomAnchor),
                suffixLabels[i].trailingAnchor.constraint(equalTo: containers[i].trailingAnchor),
            ])            
            prefixLabels[i].setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }
    
    private func loadMeanings(meanings: [Meaning]) {
        var containers:[UIView] = []
        var numberLabels:[UILabel] = []
        var definitionLabels:[UILabel] = []
        var sentenceLabels:[[UILabel]] = []
        
        appendLabels(forMeanings: meanings, containers: &containers, numberLabels: &numberLabels, definitionLabels: &definitionLabels, sentenceLabels: &sentenceLabels)
        
        for container in containers {
            meaningsStackView.addArrangedSubview(container)
        }
        
        for i in 0..<containers.count {
            NSLayoutConstraint.activate([
                numberLabels[i].topAnchor.constraint(equalTo: containers[i].topAnchor),
                numberLabels[i].leadingAnchor.constraint(equalTo: containers[i].leadingAnchor),
                numberLabels[i].widthAnchor.constraint(equalToConstant: 20),
                definitionLabels[i].firstBaselineAnchor.constraint(equalTo: numberLabels[i].firstBaselineAnchor),
                definitionLabels[i].leadingAnchor.constraint(equalTo: numberLabels[i].trailingAnchor, constant: 4),
                definitionLabels[i].trailingAnchor.constraint(equalTo: containers[i].trailingAnchor)
            ])
            if sentenceLabels[i].isEmpty {
                NSLayoutConstraint.activate([
                    definitionLabels[i].bottomAnchor.constraint(equalTo: containers[i].bottomAnchor)
                ])
            } else {
                let japaneseLabel = sentenceLabels[i][0]
                let englishLabel = sentenceLabels[i][1]
                NSLayoutConstraint.activate([
                    japaneseLabel.topAnchor.constraint(equalTo: definitionLabels[i].bottomAnchor, constant: 2),
                    japaneseLabel.leadingAnchor.constraint(equalTo: definitionLabels[i].leadingAnchor),
                    japaneseLabel.trailingAnchor.constraint(equalTo: containers[i].trailingAnchor),
                    japaneseLabel.bottomAnchor.constraint(equalTo: englishLabel.topAnchor),
                    englishLabel.leadingAnchor.constraint(equalTo: japaneseLabel.leadingAnchor),
                    englishLabel.bottomAnchor.constraint(equalTo: containers[i].bottomAnchor),
                    englishLabel.trailingAnchor.constraint(equalTo: japaneseLabel.trailingAnchor)
                ])
            }
        }
    }
    
    private func appendLabels(forMeanings meanings: [Meaning], containers: inout [UIView], numberLabels: inout [UILabel], definitionLabels: inout [UILabel], sentenceLabels: inout [[UILabel]]) {
        
        for (i, meaning) in meanings.sorted(by: {$0.order < $1.order}).enumerated() {
            guard let definitions = meaning.definitions else {return}
            let numberLabel = numberLabel(i+1)
            let definitionLabel = definitionsLabel(definitions, meaning.miscellaneousEntities)
            var japaneseSentenceLabel, englishSentenceLabel: UILabel?
            if let exampleSentences = meaning.examples {
                let exampleLabels = exampleSentenceLabels(exampleSentences)
                japaneseSentenceLabel = exampleLabels.japanese
                englishSentenceLabel = exampleLabels.english
            }
            
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(numberLabel)
            containerView.addSubview(definitionLabel)
            if let unwrappedJapaneseLabel = japaneseSentenceLabel, let unwrappedEnglishLabel = englishSentenceLabel {
                containerView.addSubview(unwrappedJapaneseLabel)
                containerView.addSubview(unwrappedEnglishLabel)
                sentenceLabels.append([unwrappedJapaneseLabel, unwrappedEnglishLabel])
            } else {
                sentenceLabels.append([])
            }
            
            containers.append(containerView)
            numberLabels.append(numberLabel)
            definitionLabels.append(definitionLabel)
        }
    }
    
    private func spellingAndReadingView(forSpellingLabel spellingLabel: UILabel, associatedReadings: [String]) -> (UIView, UILabel, UILabel)  {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let readingsLabel = suffixLabel(forReadings: associatedReadings)
        containerView.addSubview(spellingLabel)
        containerView.addSubview(readingsLabel)
        
        return (containerView, spellingLabel, readingsLabel)
    }
    
    private func prefixLabel(forSpelling spelling: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.text = "\(spelling): "
        return label
    }
    
    private func suffixLabel(forReadings readings: [String]) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        label.text = readings.joined(separator: ", ")
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    private func numberLabel(_ number: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.text = "\(number). "
        return label
    }
    
    private func definitionsLabel(_ definitions: [String], _ miscellaneousEntities: [String]?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let definitionsAttributes:[NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 22, weight: .regular)]
        let definitionsText = definitions.joined(separator: ", ") + " "
        let definitionsAttributedString = NSAttributedString(string: definitionsText, attributes: definitionsAttributes)
        
        let tagAttributes:[NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .light)]
        var tagText = ""
        if let entities = miscellaneousEntities {
            tagText = entities.map{"[\($0)]"}.joined(separator: " ")
        }
        let tagAttributedString = NSAttributedString(string: tagText, attributes: tagAttributes)
        
        label.attributedText = definitionsAttributedString + tagAttributedString
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    private func exampleSentenceLabels(_ examples: [String]) -> (japanese: UILabel, english: UILabel) {
        let japaneseSentence = examples[0]
        let englishSentence = examples[1]
        
        let japaneseLabel = UILabel()
        japaneseLabel.translatesAutoresizingMaskIntoConstraints = false
        japaneseLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        japaneseLabel.lineBreakMode = .byWordWrapping
        japaneseLabel.text = japaneseSentence
        japaneseLabel.numberOfLines = 0
        
        let englishLabel = UILabel()
        englishLabel.translatesAutoresizingMaskIntoConstraints = false
        englishLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        englishLabel.lineBreakMode = .byWordWrapping
        englishLabel.text = englishSentence
        englishLabel.numberOfLines = 0
        
        return (japaneseLabel, englishLabel)
    }
    
    // MARK: Properties
    
    private let spellingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    private let meaningsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
}
