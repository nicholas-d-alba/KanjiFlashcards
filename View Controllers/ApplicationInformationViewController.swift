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
        setUpContainerView()
        setUpLabels()
    }
    
    private func setUpContainerView() {
        containerView.addSubview(scrollView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setUpLabels() {
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(appInformationLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: appInformationLabel.topAnchor, constant: -8),
            headerLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            appInformationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            appInformationLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            appInformationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            appInformationLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        headerLabel.textColor = textColor
        appInformationLabel.textColor = textColor
    }
    
    // MARK: Properties
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "About Kanji Kitsune"
        label.textAlignment = .center
        return label
    }()
    
    private let appInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.text = appInformation
        label.numberOfLines = 0
        return label
    }()
    
}

private let appInformation = "Kanji Kitsune is a flashcard app intended to help you memorize the most commonly used characters in Japanese. It is not intended to be a replacement for other resources which are useful in learning any language, such as a language tutor or a textbook. And it is not intended for absolute beginners of the language - if that describes you, I would recommend that you start off with a textbook like Genki: An Introductory Approach to Elementary Japanese. But as long as you have a basic understanding of how hiragana, katakana, and kanji work, I hope this app can assist with kanji memorization, which is probably one of the most challenging and time-consuming hurdles in learning Japanese.\n\nThe kanji data come from developer davidluzgouveia on GitHub, and is available at https://github.com/davidluzgouveia/kanji-data\n\nThe word data comes from The JMDict project, and is available at http://www.edrdg.org/jmdict/j_jmdict.html\n\nAnd the kanji stroke diagrams come from KanjiVG, which can be reached at https://kanjivg.tagaini.net/\n\nThank you for your interest in the app - I hope it can help you in your studies. :)\n\n-Nicholas"

