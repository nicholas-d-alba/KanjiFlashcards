//
//  ApplicationInformationViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/23/21.
//

import UIKit

class ApplicationInformationViewController: UIViewController {

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        let barButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        navigationItem.title = "About"
    }

    // MARK: UI Set-Up
    
    private func setUpUI() {
        setUpHeaderLabel()
        setUpTextView()
    }
    
    private func setUpHeaderLabel() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        headerLabel.textColor = textColor
    }
    
    private func setUpTextView() {
        view.addSubview(appInformationTextView)
        NSLayoutConstraint.activate([
            appInformationTextView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            appInformationTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            appInformationTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            appInformationTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        appInformationTextView.textColor = textColor
        appInformationTextView.backgroundColor = backgroundColor
        appInformationTextView.linkTextAttributes = [
            .foregroundColor: textColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
    }
    
    // MARK: Properties

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "About Kanji Kitsune"
        label.textAlignment = .center
        return label
    }()
    
    private let appInformationTextView: UITextView = {
        guard let kanjiURL = URL(string: kanjiURLString),
              let genkiURL = URL(string: genkiURLString),
              let jmDictURL = URL(string: jmDictURLString),
              let kanjiVGURL = URL(string: kanjiVGURL),
              let kanjiSubstring = appInformation.range(of: kanjiDescriptionString),
              let genkiSubstring = appInformation.range(of: genkiDescriptionString),
              let jmDictSubstring = appInformation.range(of: jmDictDescriptionString),
              let kanjiVGSubstring = appInformation.range(of: kanjiVGDescriptionString) else {
            return UITextView()
        }
        
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        let appInformationAttributedString = NSMutableAttributedString(string: appInformation, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)])
        
        appInformationAttributedString.addAttribute(.link, value: kanjiURL, range: NSRange(kanjiSubstring, in: appInformation))
        appInformationAttributedString.addAttribute(.link, value: genkiURL, range: NSRange(genkiSubstring, in: appInformation))
        appInformationAttributedString.addAttribute(.link, value: jmDictURL, range: NSRange(jmDictSubstring, in: appInformation))
        appInformationAttributedString.addAttribute(.link, value: kanjiVGURL, range: NSRange(kanjiVGSubstring, in: appInformation))
        
        textView.attributedText = appInformationAttributedString
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        
        return textView
    }()
    
}

private let kanjiDescriptionString = "davidluzgouveia"
private let kanjiURLString = "https://github.com/davidluzgouveia/kanji-data"
private let genkiDescriptionString = "Genki"
private let genkiURLString = "https://en.m.wikipedia.org/wiki/Genki:_An_Integrated_Course_in_Elementary_Japanese"
private let jmDictDescriptionString = "The JMDict Project"
private let jmDictURLString = "https://www.edrdg.org/jmdict/j_jmdict.html"
private let kanjiVGDescriptionString = "KanjiVG"
private let kanjiVGURL = "https://kanjivg.tagaini.net"


private let appInformation = "Kanji Kitsune is a flashcard app for memorizing the most commonly used kanji, which is probably one of the most challenging and time-consuming hurdles in learning Japanese. It is intended for learners who have a basic understanding of how hiragana, katakana, and kanji work. If you are a complete beginner in Japanese, I would recommend that you start off with a textbook like \(genkiDescriptionString) before using this app.\n\nThe kanji data come from developer \(kanjiDescriptionString) on GitHub. The word data and example sentences come from \(jmDictDescriptionString). And the kanji stroke diagrams are from \(kanjiVGDescriptionString) by Ulrich Apel.\n\nThank you for your interest in the app - I hope it can help you in your studies. :)\n\n-Nicholas"

