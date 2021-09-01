//
//  HomeViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/9/21.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: UI Set-Up
    
    private func setUpUI() {
        setUpTitle()
        setUpMenu()
        view.backgroundColor = backgroundColor
    }
    
    private func setUpTitle() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        titleLabel.textColor = textColor
    }
    
    private func setUpMenu() {
        stackView.addArrangedSubview(kitsuneLabel)
        stackView.addArrangedSubview(quizButton)
        stackView.addArrangedSubview(appInformationButton)
        
        kitsuneLabel.shadowColor = contentBackgroundColor
        kitsuneLabel.shadowOffset = CGSize(width: 5, height: 10)
        quizButton.addTarget(self, action: #selector(quizButtonPressed), for: .touchUpInside)
        appInformationButton.addTarget(self, action: #selector(appInformationButtonPressed), for: .touchUpInside)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        setAppearance(forLabel: kitsuneLabel)
        setAppearance(forButtonWithLabel: quizButton)
        setAppearance(forButtonWithLabel: appInformationButton)
    }
    
    private func setUpNavigationBar() {
        let barButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        UINavigationBar.appearance().tintColor = textColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]
    }
    
    private func setAppearance(forLabel label: UILabel) {
        label.textColor = textColor
    }
    
    private func setAppearance(forButtonWithLabel button: UIButton) {
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        button.layer.borderColor = borderColor.cgColor
        button.backgroundColor = contentBackgroundColor
        if let label = button.titleLabel {
            label.textColor = textColor
            button.layer.cornerRadius = label.frame.height / 2
        }
    }
    
    // MARK: Interactivity
    
    @objc func quizButtonPressed() {
        let jlptSelectionViewController = JLPTSelectionViewController()
        navigationController?.pushViewController(jlptSelectionViewController, animated: true)
    }
    
    @objc func appInformationButtonPressed() {
        let applicationInformationViewController = ApplicationInformationViewController()
        navigationController?.pushViewController(applicationInformationViewController, animated: true)
    }
    
    // MARK: Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.text = "Kanji Kitsune"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    
    private let kitsuneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 100, weight: .heavy)
        label.text = "狐"
        return label
    }()
    
    private let quizButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Quiz", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    private let appInformationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "About", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
}
