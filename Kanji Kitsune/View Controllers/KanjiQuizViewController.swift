//
//  KanjiQuizViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/27/21.
//

import UIKit

class KanjiQuizViewController: UIViewController {

    // MARK: Initializers
    
    init(withKanjiQuiz kanjiQuiz: KanjiQuiz) {
        self.kanjiQuiz = kanjiQuiz
        super.init(nibName: nil, bundle: nil)
        navigationItem.title = "Kanji Quiz \(kanjiQuiz.index+1)/\(kanjiQuiz.quizLength)"
        loadInformation(forKanji: kanjiQuiz.currentKanji)
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
        setUpKanjiInformationLabel()
        setUpPresentSampleWordsButton()
        
        setUpDrawingSubmissionButton()
        setUpCanvas()
        setUpCanvasEditingButtons()
        setUpMemoryIndicatorButtons()
        
        rememberedKanjiButton.isHidden = true
        forgotKanjiButton.isHidden = true
    }
    
    private func setUpKanjiInformationLabel() {
        view.addSubview(kanjiInformationLabel)
        kanjiInformationLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        kanjiInformationLabel.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        kanjiInformationLabel.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        
        NSLayoutConstraint.activate([
            kanjiInformationLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            kanjiInformationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            kanjiInformationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            kanjiInformationLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20)
        ])
    }
    
    private func setUpPresentSampleWordsButton() {
        view.addSubview(sampleWordsButton)
        NSLayoutConstraint.activate([
            sampleWordsButton.topAnchor.constraint(equalTo: kanjiInformationLabel.bottomAnchor, constant: 8),
            sampleWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        sampleWordsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: sampleWordsButton)
        sampleWordsButton.addTarget(self, action: #selector(presentSampleWords), for: .touchUpInside)
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
        canvas = Canvas(withStrokeColor: ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle))
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.layer.borderWidth = 2
        canvas.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        canvas.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        
        view.addSubview(canvas)
        NSLayoutConstraint.activate([
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            canvas.bottomAnchor.constraint(equalTo: submitDrawingButton.topAnchor, constant: -8),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            canvas.heightAnchor.constraint(equalTo: canvas.widthAnchor)
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
            rememberedKanjiButton.leadingAnchor.constraint(equalTo: canvas.leadingAnchor)
        ])
        
        rememberedKanjiButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setColorsAndRounding(forButtonWithImage: rememberedKanjiButton)
        rememberedKanjiButton.addTarget(self, action: #selector(didRememberKanji), for: .touchUpInside)
        
        view.addSubview(forgotKanjiButton)
        NSLayoutConstraint.activate([
            forgotKanjiButton.centerYAnchor.constraint(equalTo: submitDrawingButton.centerYAnchor),
            forgotKanjiButton.trailingAnchor.constraint(equalTo: canvas.trailingAnchor)
        ])
        
        forgotKanjiButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        setColorsAndRounding(forButtonWithImage: forgotKanjiButton)
        forgotKanjiButton.addTarget(self, action: #selector(didNotRememberKanji), for: .touchUpInside)
    }
    
    private func loadInformation(forKanji kanji: Kanji) {
        kanjiInformationLabel.text = ""
        kanjiInformationLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        if let meanings = kanji.meanings {
            kanjiInformationLabel.text! += "\(meanings.joined(separator: ", "))\n"
        }
        if let on = kanji.onReadings {
            kanjiInformationLabel.text! += "\(on.joined(separator: ", "))\n"
        }
        if let kun = kanji.kunReadings {
            kanjiInformationLabel.text! += kun.joined(separator: ", ")
        }
    }
    
    private func switchSampleWordsButtonWithKanjiDetailsButton() {
        sampleWordsButton.removeFromSuperview()
        view.addSubview(kanjiDetailsButton)
        NSLayoutConstraint.activate([
            kanjiDetailsButton.topAnchor.constraint(equalTo: kanjiInformationLabel.bottomAnchor, constant: 8),
            kanjiDetailsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        kanjiDetailsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setColorsAndRounding(forButtonWithLabel: kanjiDetailsButton)
        kanjiDetailsButton.addTarget(self, action: #selector(presentKanjiDetails), for: .touchUpInside)
    }
    
    private func switchKanjiDetailsButtonWithSampleWordsButton() {
        kanjiDetailsButton.removeFromSuperview()
        view.addSubview(sampleWordsButton)
        NSLayoutConstraint.activate([
            sampleWordsButton.topAnchor.constraint(equalTo: kanjiInformationLabel.bottomAnchor, constant: 8),
            sampleWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        sampleWordsButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    private func setColorsAndRounding(forButtonWithLabel button: UIButton) {
        button.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        button.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        if let label = button.titleLabel {
            label.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
            button.layer.cornerRadius = label.frame.height / 2
        }
    }
    
    private func setColorsAndRounding(forButtonWithImage button: UIButton) {
        button.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        button.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        if let imageView = button.imageView {
            button.layer.cornerRadius = imageView.frame.height / 2
        }
    }
    
    // MARK: Interactivity
    
    @objc func presentSampleWords() {
        guard let hints = kanjiQuiz.currentHints else {return}
        let sampleWordsViewController = SampleWordsViewController(withHints: hints)
        present(sampleWordsViewController, animated: true, completion: nil)
    }
    
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
            kanjiInformationLabel.text = name
        }
        kanjiInformationLabel.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        
        submitDrawingButton.isHidden = true
        rememberedKanjiButton.isHidden = false
        forgotKanjiButton.isHidden = false
        clearCanvasButton.isHidden = true
        undoStrokeButton.isHidden = true
        
        canvas.isUserInteractionEnabled = false
        switchSampleWordsButtonWithKanjiDetailsButton()
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
        submitDrawingButton.isHidden = false
        rememberedKanjiButton.isHidden = true
        forgotKanjiButton.isHidden = true
        clearCanvasButton.isHidden = false
        undoStrokeButton.isHidden = false
        
        canvas.isUserInteractionEnabled = true
        switchKanjiDetailsButtonWithSampleWordsButton()
        
        if kanjiQuiz.isCompleted {
            let kanjiRemembered = kanjiQuiz.kanjiRemembered
            let totalKanji = kanjiQuiz.quizLength
            let completionViewController = KanjiQuizCompletionViewController(kanjiRemembered: kanjiRemembered, totalKanji: totalKanji)
            present(completionViewController, animated: true) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            loadInformation(forKanji: kanjiQuiz.currentKanji)
            navigationItem.title = "Kanji Quiz \(kanjiQuiz.index+1)/\(kanjiQuiz.quizLength)"
            clearCanvas()
        }
    }
    
    // MARK: Properties
    
    private var kanjiInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.layer.borderWidth = 2
        return label
    }()
    
    private var sampleWordsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        let attributedTitle = NSAttributedString(string: "Show Sample Words", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private let kanjiDetailsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 2
        let attributedTitle = NSAttributedString(string: "Show Kanji Details", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)])
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
        let attributedTitle = NSAttributedString(string: "Submit", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
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
    
    private var kanjiQuiz: KanjiQuiz
}
