//
//  SampleWordsViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/28/21.
//

import UIKit

class SampleWordsViewController: UIViewController {

    // MARK: Initializers
    
    init(withHints hints: [Hint]) {
        super.init(nibName: nil, bundle: nil)
        var attributedHints = NSAttributedString()
        for (i, hint) in hints.enumerated() {
            let readings = "\(i+1). " + hint.readings.joined(separator: ", ") + ": "
            let meanings = hint.meanings.joined(separator: ", ") + "\n\n"
            let attributedPrefixString = NSAttributedString(string: readings, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
            let attributedSuffixString = NSAttributedString(string: meanings, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)])
            let attributedString = attributedPrefixString + attributedSuffixString
            attributedHints = attributedHints + attributedString
        }
        sampleWordsLabel.attributedText = attributedHints
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
        setUpTitleLabel()
        setUpScrollView()
    }
    
    private func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        scrollView.addSubview(sampleWordsLabel)
        sampleWordsLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            sampleWordsLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            sampleWordsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            sampleWordsLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            sampleWordsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            sampleWordsLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "Sample Words"
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sampleWordsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        label.text = ""
        return label
    }()
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}
