//
//  KanjiQuizViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/27/21.
//

import UIKit

class KanjiQuizViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Initializers
    
    init(withKanjiQuiz kanjiQuiz: KanjiQuiz) {
        self.kanjiQuiz = kanjiQuiz
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Kanji Quiz \(kanjiQuiz.index+1)/\(kanjiQuiz.quizLength)"
        loadInformation(forKanji: kanjiQuiz.currentKanji, hints: kanjiQuiz.currentHints)
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
        
        setUpDrawingSubmissionButton()
        setUpCanvas()
        setUpCanvasEditingButtons()
        setUpKanjiDetailsButton()
        setUpKanjiInformationContainer()
        setUpMemoryIndicatorButtons()
        
        presentRelevantViews(isQuizzing: true)
    }
    
    private func setUpKanjiInformationContainer() {
        kanjiInformationScrollView.addSubview(kanjiInformationLabel)
        kanjiInformationScrollView.addSubview(kanjiHintsLabel)
        NSLayoutConstraint.activate([
            kanjiInformationLabel.topAnchor.constraint(equalTo: kanjiInformationScrollView.topAnchor, constant: 8),
            kanjiInformationLabel.leadingAnchor.constraint(equalTo: kanjiInformationScrollView.leadingAnchor, constant: 8),
            kanjiInformationLabel.bottomAnchor.constraint(equalTo: kanjiHintsLabel.topAnchor),
            kanjiInformationLabel.trailingAnchor.constraint(equalTo: kanjiInformationScrollView.trailingAnchor, constant: -8),
            kanjiInformationLabel.widthAnchor.constraint(equalTo: kanjiInformationScrollView.widthAnchor, constant: -16),
            kanjiHintsLabel.leadingAnchor.constraint(equalTo: kanjiInformationScrollView.leadingAnchor, constant: 8),
            kanjiHintsLabel.bottomAnchor.constraint(equalTo: kanjiInformationScrollView.bottomAnchor),
            kanjiHintsLabel.trailingAnchor.constraint(equalTo: kanjiInformationScrollView.trailingAnchor, constant: -8),
            kanjiHintsLabel.widthAnchor.constraint(equalTo: kanjiInformationScrollView.widthAnchor, constant: -16)
        ])
        
        kanjiInformationContainer.addSubview(kanjiInformationScrollView)
        NSLayoutConstraint.activate([
            kanjiInformationScrollView.topAnchor.constraint(equalTo: kanjiInformationContainer.topAnchor),
            kanjiInformationScrollView.leadingAnchor.constraint(equalTo: kanjiInformationContainer.leadingAnchor),
            kanjiInformationScrollView.bottomAnchor.constraint(equalTo: kanjiInformationContainer.bottomAnchor),
            kanjiInformationScrollView.trailingAnchor.constraint(equalTo: kanjiInformationContainer.trailingAnchor)
        ])
        
        kanjiInformationContainer.addSubview(kanjiNameLabel)
        NSLayoutConstraint.activate([
            kanjiNameLabel.centerXAnchor.constraint(equalTo: kanjiInformationContainer.centerXAnchor),
            kanjiNameLabel.centerYAnchor.constraint(equalTo: kanjiInformationContainer.centerYAnchor)
        ])
        
        view.addSubview(kanjiInformationContainer)
        NSLayoutConstraint.activate([
            kanjiInformationContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            kanjiInformationContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            kanjiInformationContainer.bottomAnchor.constraint(equalTo: kanjiDetailsButton.topAnchor, constant: -8),
            kanjiInformationContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        kanjiInformationContainer.backgroundColor = contentBackgroundColor
        kanjiInformationContainer.layer.borderColor = borderColor.cgColor
        setColors(forLabel: kanjiInformationLabel)
        setColors(forLabel: kanjiHintsLabel)
        setColors(forLabel: kanjiNameLabel)
    }
    
    private func setUpKanjiDetailsButton() {
        view.addSubview(kanjiDetailsButton)
        NSLayoutConstraint.activate([
            kanjiDetailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            kanjiDetailsButton.bottomAnchor.constraint(equalTo: undoStrokeButton.topAnchor, constant: -8)
        ])
        
        kanjiDetailsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: kanjiDetailsButton)
        kanjiDetailsButton.addTarget(self, action: #selector(presentKanjiDetails), for: .touchUpInside)
    }
    
    private func setUpDrawingSubmissionButton() {
        view.addSubview(submitDrawingButton)
        NSLayoutConstraint.activate([
            submitDrawingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitDrawingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
        
        submitDrawingButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: submitDrawingButton)
        submitDrawingButton.addTarget(self, action: #selector(submitDrawing), for: .touchUpInside)
    }
    
    private func setUpCanvas() {
        canvas = Canvas(withStrokeColor: textColor)
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.layer.borderWidth = 2
        canvas.layer.borderColor = borderColor.cgColor
        canvas.backgroundColor = contentBackgroundColor
        
        view.addSubview(canvas)
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 8),
            canvas.bottomAnchor.constraint(equalTo: submitDrawingButton.topAnchor, constant: -8),
            canvas.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -8),
            canvas.heightAnchor.constraint(equalTo: canvas.widthAnchor),
            canvas.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.50),
            canvas.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setUpCanvasEditingButtons() {
        view.addSubview(clearCanvasButton)
        NSLayoutConstraint.activate([
            clearCanvasButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor),
            clearCanvasButton.bottomAnchor.constraint(equalTo: canvas.topAnchor, constant: -8),
        ])
        
        clearCanvasButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: clearCanvasButton)
        clearCanvasButton.addTarget(self, action: #selector(clearCanvas), for: .touchUpInside)
        
        view.addSubview(undoStrokeButton)
        NSLayoutConstraint.activate([
            undoStrokeButton.bottomAnchor.constraint(equalTo: canvas.topAnchor, constant: -8),
            undoStrokeButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor)
        ])
        
        undoStrokeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: undoStrokeButton)
        undoStrokeButton.addTarget(self, action: #selector(undoStroke), for: .touchUpInside)
    }
    
    private func setUpMemoryIndicatorButtons() {
        view.addSubview(rememberedKanjiButton)
        NSLayoutConstraint.activate([
            rememberedKanjiButton.centerYAnchor.constraint(equalTo: submitDrawingButton.centerYAnchor),
            rememberedKanjiButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor),
            rememberedKanjiButton.widthAnchor.constraint(equalTo: rememberedKanjiButton.heightAnchor),
            rememberedKanjiButton.heightAnchor.constraint(equalTo: submitDrawingButton.heightAnchor)
        ])
        
        rememberedKanjiButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setColorsAndRounding(forButtonWithImage: rememberedKanjiButton)
        rememberedKanjiButton.addTarget(self, action: #selector(didRememberKanji), for: .touchUpInside)
        
        view.addSubview(forgotKanjiButton)
        NSLayoutConstraint.activate([
            forgotKanjiButton.centerYAnchor.constraint(equalTo: submitDrawingButton.centerYAnchor),
            forgotKanjiButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor),
            forgotKanjiButton.widthAnchor.constraint(equalTo: forgotKanjiButton.heightAnchor),
            forgotKanjiButton.heightAnchor.constraint(equalTo: submitDrawingButton.heightAnchor)
        ])
        
        forgotKanjiButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setColorsAndRounding(forButtonWithImage: forgotKanjiButton)
        forgotKanjiButton.addTarget(self, action: #selector(didNotRememberKanji), for: .touchUpInside)
    }
    
    private func loadInformation(forKanji kanji: Kanji, hints: [Hint]?) {
        kanjiInformationLabel.text = ""
        if let meanings = kanji.meanings {
            kanjiInformationLabel.text! += "\(meanings.joined(separator: ", "))\n"
        }
        if let on = kanji.onReadings, !kanji.onReadings!.isEmpty {
            kanjiInformationLabel.text! += "\(on.joined(separator: ", "))\n"
        }
        if let kun = kanji.kunReadings, !kanji.kunReadings!.isEmpty {
            kanjiInformationLabel.text! += "\(kun.joined(separator: ", "))\n"
        }
        
        guard let hints = hints else {
            return
        }
        var attributedHints = NSAttributedString()
        for (i, hint) in hints.enumerated() {
            let readings = "\(i+1). " + hint.readings.joined(separator: ", ") + ": "
            let meanings = hint.meanings.joined(separator: ", ") + "\n"
            let attributedPrefixString = NSAttributedString(string: readings, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
            let attributedSuffixString = NSAttributedString(string: meanings, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)])
            let attributedString = attributedPrefixString + attributedSuffixString
            attributedHints = attributedHints + attributedString
        }
        kanjiHintsLabel.attributedText = attributedHints
    }
    
    private func setColorsAndRounding(forButtonWithLabel button: UIButton) {
        button.backgroundColor = contentBackgroundColor
        button.layer.borderColor = borderColor.cgColor
        if let label = button.titleLabel {
            label.textColor = textColor
            button.layer.cornerRadius = label.frame.height / 2
        }
    }
    
    private func setColorsAndRounding(forButtonWithImage button: UIButton) {
        button.backgroundColor = contentBackgroundColor
        button.layer.borderColor = borderColor.cgColor
        if let imageView = button.imageView {
            button.layer.cornerRadius = imageView.frame.height / 2
        }
    }
    
    private func setColors(forLabel label: UILabel) {
        label.textColor = textColor
    }
    
    // MARK: Quiz Completion UI Set-Up
    
    func displayResults() {
        removeQuizzingSubviews()
        navigationItem.title = "Quiz Complete"
        
        view.addSubview(forgottenKanjiLabel)
        view.addSubview(scoreLabel)
        forgottenKanjiLabel.textColor = textColor
        scoreLabel.textColor = textColor
        scoreLabel.text = "Score: \(kanjiQuiz.kanjiRemembered.count)/\(kanjiQuiz.quizLength)"
        
        if kanjiQuiz.kanjiForgotten.isEmpty {
            displayResultsForPerfectScore()
        } else {
            displayResultsForImperfectScore()
        }
    }
    
    private func displayResultsForPerfectScore() {
        forgottenKanjiLabel.text = "No Unknown Kanji"
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(scoreLabel)
        stackView.addArrangedSubview(forgottenKanjiLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func displayResultsForImperfectScore() {
        view.addSubview(forgottenKanjiTableView)
        forgottenKanjiTableView.dataSource = self
        forgottenKanjiTableView.delegate = self
        forgottenKanjiTableView.register(KanjiTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        NSLayoutConstraint.activate([
            forgottenKanjiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            forgottenKanjiTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            forgottenKanjiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            forgottenKanjiTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.70)
        ])
        forgottenKanjiTableView.layer.borderWidth = 2.0
        forgottenKanjiTableView.layer.borderColor = borderColor.cgColor
        forgottenKanjiTableView.backgroundColor = backgroundColor
        
        NSLayoutConstraint.activate([
            forgottenKanjiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            forgottenKanjiLabel.bottomAnchor.constraint(equalTo: forgottenKanjiTableView.topAnchor, constant: -8),
            forgottenKanjiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scoreLabel.bottomAnchor.constraint(equalTo: forgottenKanjiLabel.topAnchor, constant: -16),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    
    }
    
    private func removeQuizzingSubviews() {
        kanjiInformationContainer.removeFromSuperview()
        kanjiInformationScrollView.removeFromSuperview()
        kanjiInformationLabel.removeFromSuperview()
        kanjiHintsLabel.removeFromSuperview()
        kanjiNameLabel.removeFromSuperview()
        kanjiDetailsButton.removeFromSuperview()
        clearCanvasButton.removeFromSuperview()
        undoStrokeButton.removeFromSuperview()
        canvas.removeFromSuperview()
        submitDrawingButton.removeFromSuperview()
        rememberedKanjiButton.removeFromSuperview()
        forgotKanjiButton.removeFromSuperview()
        
    }
    
    // MARK: Interactivity
    
    @objc func presentKanjiDetails() {
        let kanjiDetailsViewController = KanjiDetailsViewController(withKanji: kanjiQuiz.currentKanji, words: kanjiQuiz.currentWords)
        present(kanjiDetailsViewController, animated: true, completion: nil)
    }
    
    @objc func clearCanvas() {
        canvas.clearScreen()
    }
    
    @objc func undoStroke() {
        canvas.undoStroke()
    }
    
    @objc func submitDrawing() {
        if let name = kanjiQuiz.currentKanji.name {
            kanjiNameLabel.text = name
        }
        kanjiInformationLabel.text = ""
        kanjiHintsLabel.text = ""
        canvas.isUserInteractionEnabled = false
        presentRelevantViews(isQuizzing: false)
    }
    
    @objc func didRememberKanji() {
        kanjiQuiz.kanjiWasRemembered()
        memoryIndicatorButtonPressed()
    }
    
    @objc func didNotRememberKanji() {
        kanjiQuiz.kanjiWasForgotten()
        memoryIndicatorButtonPressed()
    }
    
    private func memoryIndicatorButtonPressed() {
        canvas.isUserInteractionEnabled = true
        presentRelevantViews(isQuizzing: true)
        
        if kanjiQuiz.isCompleted {
            kanjiForgotten = kanjiQuiz.kanjiForgotten
            wordsForForgottenKanji = kanjiQuiz.wordsForForgottenKanji
            displayResults()
        } else {
            loadInformation(forKanji: kanjiQuiz.currentKanji, hints: kanjiQuiz.currentHints)
            navigationItem.title = "Kanji Quiz \(kanjiQuiz.index+1)/\(kanjiQuiz.quizLength)"
            clearCanvas()
        }
    }
    
    private func presentRelevantViews(isQuizzing: Bool) {
        kanjiInformationScrollView.isHidden = !isQuizzing
        kanjiNameLabel.isHidden = isQuizzing
        
        clearCanvasButton.isHidden = !isQuizzing
        kanjiDetailsButton.isHidden = isQuizzing
        undoStrokeButton.isHidden = !isQuizzing
        
        rememberedKanjiButton.isHidden = isQuizzing
        submitDrawingButton.isHidden = !isQuizzing
        forgotKanjiButton.isHidden = isQuizzing
    }
    
    // MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kanjiQuiz.kanjiForgotten.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let kanji = kanjiForgotten, let cell = forgottenKanjiTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? KanjiTableViewCell else {
            return UITableViewCell()
        }
        cell.loadDetails(forKanji: kanji[indexPath.row])
        cell.setColors(forViewController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedKanji = kanjiQuiz.kanjiForgotten[indexPath.row]
        let selectedWords = kanjiQuiz.wordsForForgottenKanji[indexPath.row]
        let kanjiDetailsViewController = KanjiDetailsViewController(withKanji: selectedKanji, words: selectedWords)
        present(kanjiDetailsViewController, animated: true, completion: nil)
    }
    
    // MARK: Properties
    
    private var kanjiInformationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        return view
    }()
    
    private var kanjiInformationScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var kanjiInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var kanjiHintsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let kanjiNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let kanjiDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        let attributedTitle = NSAttributedString(string: "Show Kanji Details", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private let clearCanvasButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Clear", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    private let undoStrokeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Undo", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    private var canvas: Canvas = {
        let canvas = Canvas(withStrokeColor: .black)
        return canvas
    }()
    
    private let submitDrawingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Submit", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    private let rememberedKanjiButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.layer.borderWidth = 2
        button.tintColor = .systemGreen
        return button
    }()
    
    private let forgotKanjiButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.layer.borderWidth = 2
        button.tintColor = .systemRed
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let forgottenKanjiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = "Unknown Kanji"
        return label
    }()
    
    private let forgottenKanjiTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var kanjiQuiz: KanjiQuiz
    private let cellReuseIdentifier = "cellReuseIdentifier"
    private var kanjiForgotten: [Kanji]?
    private var wordsForForgottenKanji: [[Word]?] = []
}
