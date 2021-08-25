//
//  KanjiDetailsViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/29/21.
//

import SVGKit
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
        view.backgroundColor = backgroundColor
        setUpContainerView()
        setUpKanjiInformation()
        
        setUpOnReadingsLabels()
        setUpKunReadingsLabels()
        setUpJLPTLabels()
        setUpStrokesLabels()
        setUpMasteryLabels()
        
        setUpTableView()
        setUpKanjiStrokesImageView()
        setUpButtons()
        
        sampleWordsButtonPressed()
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
        nameLabel.textColor = textColor
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            nameLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.25),
        ])
        
        containerView.addSubview(meaningsLabel)
        meaningsLabel.textColor = textColor
        NSLayoutConstraint.activate([
            meaningsLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            meaningsLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            meaningsLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            meaningsLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75, constant: -8)
        ])
        
    }
    
    private func setUpOnReadingsLabels() {
        containerView.addSubview(onPrefixLabel)
        onPrefixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            onPrefixLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            onPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
        
        containerView.addSubview(onSuffixLabel)
        onSuffixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            onSuffixLabel.topAnchor.constraint(equalTo: onPrefixLabel.topAnchor),
            onSuffixLabel.leadingAnchor.constraint(equalTo: onPrefixLabel.trailingAnchor),
            onSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            onSuffixLabel.firstBaselineAnchor.constraint(equalTo: onPrefixLabel.firstBaselineAnchor)
        ])
    }
    
    private func setUpKunReadingsLabels() {
        containerView.addSubview(kunPrefixLabel)
        kunPrefixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            kunPrefixLabel.topAnchor.constraint(equalTo: onSuffixLabel.bottomAnchor),
            kunPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
        ])
        
        containerView.addSubview(kunSuffixLabel)
        kunSuffixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            kunSuffixLabel.topAnchor.constraint(equalTo: onSuffixLabel.bottomAnchor),
            kunSuffixLabel.leadingAnchor.constraint(equalTo: kunPrefixLabel.trailingAnchor),
            kunSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            kunSuffixLabel.firstBaselineAnchor.constraint(equalTo: kunPrefixLabel.firstBaselineAnchor)
        ])
    }
    
    private func setUpJLPTLabels() {
        containerView.addSubview(jlptPrefixLabel)
        jlptPrefixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            jlptPrefixLabel.topAnchor.constraint(equalTo: kunSuffixLabel.bottomAnchor),
            jlptPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            
        ])
        
        containerView.addSubview(jlptSuffixLabel)
        jlptSuffixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            jlptSuffixLabel.topAnchor.constraint(equalTo: jlptPrefixLabel.topAnchor),
            jlptSuffixLabel.leadingAnchor.constraint(equalTo: jlptPrefixLabel.trailingAnchor),
            jlptSuffixLabel.bottomAnchor.constraint(equalTo: jlptPrefixLabel.bottomAnchor),
            jlptSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setUpStrokesLabels() {
        containerView.addSubview(strokesPrefixLabel)
        strokesPrefixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            strokesPrefixLabel.topAnchor.constraint(equalTo: jlptSuffixLabel.bottomAnchor),
            strokesPrefixLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
        
        containerView.addSubview(strokesSuffixLabel)
        strokesSuffixLabel.textColor = textColor
        NSLayoutConstraint.activate([
            strokesSuffixLabel.topAnchor.constraint(equalTo: strokesPrefixLabel.topAnchor),
            strokesSuffixLabel.leadingAnchor.constraint(equalTo: strokesPrefixLabel.trailingAnchor),
            strokesSuffixLabel.bottomAnchor.constraint(equalTo: strokesPrefixLabel.bottomAnchor),
            strokesSuffixLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setUpMasteryLabels() {
        containerView.addSubview(masteryPrefixLabel)
        masteryPrefixLabel.textColor = textColor
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
        masterySuffixLabel.textColor = textColor
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
        wordsTableView.layer.borderColor = borderColor.cgColor
        wordsTableView.rowHeight = UITableView.automaticDimension
        wordsTableView.estimatedRowHeight = 88
        wordsTableView.backgroundColor = backgroundColor
        
        NSLayoutConstraint.activate([
            wordsTableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            wordsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            wordsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wordsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setUpKanjiStrokesImageView() {
        view.addSubview(kanjiStrokesImageView)
        NSLayoutConstraint.activate([
            kanjiStrokesImageView.centerYAnchor.constraint(equalTo: wordsTableView.centerYAnchor),
            kanjiStrokesImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            kanjiStrokesImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            kanjiStrokesImageView.widthAnchor.constraint(equalTo: kanjiStrokesImageView.heightAnchor)
        ])
    }
    
    private func setUpButtons() {
        view.addSubview(showSampleWordsButton)
        view.addSubview(showKanjiStrokesButton)
        showSampleWordsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        showKanjiStrokesButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        NSLayoutConstraint.activate([
            showSampleWordsButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            showSampleWordsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            showKanjiStrokesButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            showKanjiStrokesButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        setColorsAndRounding(forButtonWithLabel: showSampleWordsButton)
        setColorsAndRounding(forButtonWithLabel: showKanjiStrokesButton)
        
        showSampleWordsButton.addTarget(self, action: #selector(sampleWordsButtonPressed), for: .touchUpInside)
        showKanjiStrokesButton.addTarget(self, action: #selector(strokeOrderButtonPressed), for: .touchUpInside)
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
        masterySuffixLabel.text = masteryString(for: Int(kanji.mastery))
        
        guard let image = SVGKImage(named: name).uiImage else {
            return
        }
        kanjiStrokesImageView.image = image.withTintColor(textColor)
        kanjiStrokesImageView.backgroundColor = backgroundColor
    }
    
    private func setColorsAndRounding(forButtonWithLabel button: UIButton) {
        button.backgroundColor = contentBackgroundColor
        button.layer.borderColor = borderColor.cgColor
        if let label = button.titleLabel {
            label.textColor = textColor
            button.layer.cornerRadius = label.frame.height / 2
        }
    }
    
    @objc func sampleWordsButtonPressed() {
        presentRelevantViews(isViewingStrokeOrder: false)
    }
    
    @objc func strokeOrderButtonPressed() {
        presentRelevantViews(isViewingStrokeOrder: true)
    }
    
    private func presentRelevantViews(isViewingStrokeOrder: Bool) {
        showSampleWordsButton.isHidden = !isViewingStrokeOrder
        showKanjiStrokesButton.isHidden = isViewingStrokeOrder
        wordsTableView.isHidden = isViewingStrokeOrder
        kanjiStrokesImageView.isHidden = !isViewingStrokeOrder
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
        dictionaryEntryCell.setColors(forViewController: self)
        dictionaryEntryCell.tintColor = textColor
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
    
    private let showKanjiStrokesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Show Strokes", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.borderWidth = 1.0
        return button
    }()
    
    private let showSampleWordsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedText = NSAttributedString(string: "Show Words", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.borderWidth = 1.0
        return button
    }()
    
    private let wordsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 2.0
        return tableView
    }()
    
    private let kanjiStrokesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var wordList:[Word]? = []
    
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
}

let placeholderText = "Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing. Hello this is just a very unnecessarily long string that I am going to use to test the ability of the app to adjust to strings that are not going to have nearly as much redundant length as the one I am currently using for testing."
