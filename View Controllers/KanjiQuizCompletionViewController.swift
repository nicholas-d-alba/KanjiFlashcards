//
//  KanjiQuizCompletionViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/28/21.
//

import UIKit

class KanjiQuizCompletionViewController: UIViewController {

    // MARK: Initializers
    
    init(kanjiRemembered remembered: Int, totalKanji total: Int) {
        super.init(nibName: nil, bundle: nil)
        resultsLabel.text = "Remembered: \(remembered)/\(total)"
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
        setUpTitleLabel()
        setUpResultsLabel()
    }

    private func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = textColor
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setUpResultsLabel() {
        view.addSubview(resultsLabel)
        resultsLabel.textColor = textColor
        NSLayoutConstraint.activate([
            resultsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Completed Kanji Quiz"
        return label
    }()
    
    private let resultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
}
