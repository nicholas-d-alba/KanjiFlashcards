//
//  KanjiDetailsViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/29/21.
//

import UIKit

class KanjiDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Initializers
    
    init(withKanji kanji: Kanji, words: [Word]?) {
        super.init(nibName: nil, bundle: nil)
        loadDetails(forKanji: kanji)
        wordList = words
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }

    // MARK: UI Set-Up
        
    private func setUpUI() {
        view.backgroundColor = ColorPalette.backgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        setUpContainerView()
        setUpKanjiInformation()
        
        setUpOnReadingsLabels()
        setUpKunReadingsLabels()
        setUpJLPTLabels()
        setUpStrokesLabels()
        setUpMasteryLabels()
        
        setUpTableView()
    }
    
    private func setUpContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
    }
    
    private func setUpKanjiInformation() {
        
        containerView.addSubview(nameLabel)
        nameLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
        ])
        
        containerView.addSubview(meaningsLabel)
        meaningsLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            meaningsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            meaningsLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            meaningsLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            meaningsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75, constant: -8)
        ])
        
    }
    
    private func setUpOnReadingsLabels() {
        containerView.addSubview(onPrefixLabel)
        onPrefixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            onPrefixLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            onPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
        
        containerView.addSubview(onSuffixLabel)
        onSuffixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            onSuffixLabel.topAnchor.constraint(equalTo: onPrefixLabel.topAnchor),
            onSuffixLabel.leadingAnchor.constraint(equalTo: onPrefixLabel.trailingAnchor),
            onSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            onSuffixLabel.firstBaselineAnchor.constraint(equalTo: onPrefixLabel.firstBaselineAnchor)
        ])
    }
    
    private func setUpKunReadingsLabels() {
        containerView.addSubview(kunPrefixLabel)
        kunPrefixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            kunPrefixLabel.topAnchor.constraint(equalTo: onSuffixLabel.bottomAnchor),
            kunPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
        
        containerView.addSubview(kunSuffixLabel)
        kunSuffixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            kunSuffixLabel.topAnchor.constraint(equalTo: onSuffixLabel.bottomAnchor),
            kunSuffixLabel.leadingAnchor.constraint(equalTo: kunPrefixLabel.trailingAnchor),
            kunSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            kunSuffixLabel.firstBaselineAnchor.constraint(equalTo: kunPrefixLabel.firstBaselineAnchor)
        ])
    }
    
    private func setUpJLPTLabels() {
        containerView.addSubview(jlptPrefixLabel)
        jlptPrefixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            jlptPrefixLabel.topAnchor.constraint(equalTo: kunSuffixLabel.bottomAnchor),
            jlptPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
        ])
        
        containerView.addSubview(jlptSuffixLabel)
        jlptSuffixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            jlptSuffixLabel.topAnchor.constraint(equalTo: jlptPrefixLabel.topAnchor),
            jlptSuffixLabel.leadingAnchor.constraint(equalTo: jlptPrefixLabel.trailingAnchor),
            jlptSuffixLabel.bottomAnchor.constraint(equalTo: jlptPrefixLabel.bottomAnchor),
            jlptSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setUpStrokesLabels() {
        containerView.addSubview(strokesPrefixLabel)
        strokesPrefixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            strokesPrefixLabel.topAnchor.constraint(equalTo: jlptSuffixLabel.bottomAnchor),
            strokesPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        
        containerView.addSubview(strokesSuffixLabel)
        strokesSuffixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            strokesSuffixLabel.topAnchor.constraint(equalTo: strokesPrefixLabel.topAnchor),
            strokesSuffixLabel.leadingAnchor.constraint(equalTo: strokesPrefixLabel.trailingAnchor),
            strokesSuffixLabel.bottomAnchor.constraint(equalTo: strokesPrefixLabel.bottomAnchor),
            strokesSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setUpMasteryLabels() {
        containerView.addSubview(masteryPrefixLabel)
        masteryPrefixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            masteryPrefixLabel.topAnchor.constraint(equalTo: strokesPrefixLabel.bottomAnchor),
            masteryPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            masteryPrefixLabel.widthAnchor.constraint(equalToConstant: masteryPrefixLabel.intrinsicContentSize.width),
            jlptPrefixLabel.widthAnchor.constraint(equalTo: masteryPrefixLabel.widthAnchor),
            strokesPrefixLabel.widthAnchor.constraint(equalTo: masteryPrefixLabel.widthAnchor),
            kunPrefixLabel.widthAnchor.constraint(equalTo: masteryPrefixLabel.widthAnchor),
            onPrefixLabel.widthAnchor.constraint(equalTo: masteryPrefixLabel.widthAnchor)
        ])
        
        containerView.addSubview(masterySuffixLabel)
        masterySuffixLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            masterySuffixLabel.topAnchor.constraint(equalTo: masteryPrefixLabel.topAnchor),
            masterySuffixLabel.leadingAnchor.constraint(equalTo: masteryPrefixLabel.trailingAnchor),
            masterySuffixLabel.bottomAnchor.constraint(equalTo: masteryPrefixLabel.bottomAnchor),
            masterySuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: masterySuffixLabel.bottomAnchor)
        ])
    }
    

    private func setUpTableView() {
        view.addSubview(wordsTableView)
        wordsTableView.dataSource = self
        wordsTableView.delegate = self
        wordsTableView.register(DictionaryEntryTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        wordsTableView.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        wordsTableView.rowHeight = UITableView.automaticDimension
        wordsTableView.estimatedRowHeight = 88
        
        NSLayoutConstraint.activate([
            wordsTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            wordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            wordsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    
    
    private func loadDetails(forKanji kanji: Kanji) {
        guard let name = kanji.name, let meanings = kanji.meanings else {
            return
        }
        
        nameLabel.text = name
        meaningsLabel.text = meanings.joined(separator: ", ")
        
        if let onReadings = kanji.onReadings, !onReadings.isEmpty {
            onSuffixLabel.text = onReadings.joined(separator: ", ")
        }
        if let kunReadings = kanji.kunReadings, !kunReadings.isEmpty {
            kunSuffixLabel.text = kunReadings.joined(separator: ", ")
        }
        
        jlptSuffixLabel.text = "N\(kanji.jlpt)"
        strokesSuffixLabel.text = "\(kanji.strokes)"
        masterySuffixLabel.text = "\(kanji.mastery)"
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordList == nil ? 0 : wordList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let words = wordList, let dictionaryEntryCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? DictionaryEntryTableViewCell else {
            return UITableViewCell()
        }
        dictionaryEntryCell.loadDetails(forWord: words[indexPath.row])
        dictionaryEntryCell.setColors(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        return dictionaryEntryCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let meaningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let onPrefixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "On: "
        return label
    }()
    
    private let onSuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.text = "(none)"
        return label
    }()
    
    private let kunPrefixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Kun: "
        return label
    }()
    
    private let kunSuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.text = "(none)"
        return label
    }()
    
    private let jlptPrefixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .natural
        label.text = "JLPT: "
        return label
    }()
    
    private let jlptSuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .natural
        label.text = ""
        return label
    }()
    
    private let strokesPrefixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .natural
        label.text = "Strokes: "
        return label
    }()
    
    private let strokesSuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .natural
        label.text = ""
        return label
    }()
    
    private let masteryPrefixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .natural
        label.text = "Familiarity: "
        return label
    }()
    
    private let masterySuffixLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .natural
        label.text = ""
        return label
    }()
    
    private let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 2.0
        return tableView
    }()

    private var wordList:[Word]? = []
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
}

let placeholderText = "Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing."
