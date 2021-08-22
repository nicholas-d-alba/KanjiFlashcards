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
        spellingAndReadingsLabel.textColor = viewController.textColor
        meaningsLabel.textColor = viewController.textColor
    }
    
    private func setUpUI() {
        contentView.addSubview(spellingAndReadingsLabel)
        NSLayoutConstraint.activate([
            spellingAndReadingsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            spellingAndReadingsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            spellingAndReadingsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
        
        contentView.addSubview(meaningsLabel)
        NSLayoutConstraint.activate([
            meaningsLabel.topAnchor.constraint(equalTo: spellingAndReadingsLabel.bottomAnchor),
            meaningsLabel.leadingAnchor.constraint(equalTo: spellingAndReadingsLabel.leadingAnchor, constant: 16),
            meaningsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            meaningsLabel.trailingAnchor.constraint(equalTo: spellingAndReadingsLabel.trailingAnchor)
        ])
    }
    
    func loadDetails(forWord word: Word) {
        guard let spellingsArray = word.kanjiSpellings, let readingsArray = word.kanaReadings?.allObjects as? [KanaReading], let meanings = word.meanings?.allObjects as? [Meaning] else {
            return
        }
        
        var attributedText = NSAttributedString(string: "")
        for (i, spelling) in spellingsArray.enumerated() {
            let spellingText = "\(spelling): "
            let relevantReadings = readingsArray.filter {
                $0.restrictions == nil || $0.restrictions!.contains(spelling)
            }
            var unwrappedRelevantReadings:[String] = []
            for reading in relevantReadings {
                if let text = reading.reading {
                    unwrappedRelevantReadings.append(text)
                }
            }
            var readingsText = unwrappedRelevantReadings.joined(separator: ", ")
            if i+1 < spellingsArray.count {
                readingsText += "\n"
            }
            
            let spellingAttributedString = NSAttributedString(string: spellingText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .bold)])
            let readingsAttributedString = NSAttributedString(string: readingsText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .regular)])
            let attributedLine = spellingAttributedString + readingsAttributedString
            attributedText = attributedText + attributedLine
        }
        
        spellingAndReadingsLabel.attributedText = attributedText
        
        var meaningsAttributedString = NSAttributedString(string: "")
        for (i, meaning) in meanings.sorted(by: {$0.order < $1.order}).enumerated() {
            guard let unwrappedDefinitions = meaning.definitions else {
                return
            }
            var definitionsText = "\(i+1). \(unwrappedDefinitions.joined(separator: ", "))"
            if i+1 < meanings.count || meaning.examples != nil {
                definitionsText += "\n"
            }
            
            let definitionsAttributedString = NSAttributedString(string: definitionsText, attributes: definitionAttributes)
            meaningsAttributedString = meaningsAttributedString + definitionsAttributedString
            
            if let examples = meaning.examples {
                var examplesString = examples.map {"• " + $0}.joined(separator: "\n")
                if i+1 < meanings.count {
                    examplesString += "\n"
                }
                let examplesAttributedString = NSAttributedString(string: examplesString, attributes: examplesAttributes)
                meaningsAttributedString = meaningsAttributedString + examplesAttributedString
            }
        }
        
        meaningsLabel.attributedText = meaningsAttributedString
    }

    // MARK: Properties
    
    private let spellingAndReadingsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let meaningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let definitionAttributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .regular)]
    private let examplesAttributes:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)]
    
}
