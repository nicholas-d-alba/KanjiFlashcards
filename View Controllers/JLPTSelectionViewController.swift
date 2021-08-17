//
//  ViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 6/15/21.
//

import CoreData
import UIKit

class JLPTSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: ViewController Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpUI()
        let barButtonItem = UIBarButtonItem(title: "LS", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        navigationItem.title = "Level Selection"
    
    }
    
    // MARK: UI Set-Up
    
    private func setUpUI() {
        view.backgroundColor = backgroundColor
        setUpTableView()
        setUpStartQuizButton()
    }
    
    private func setUpTableView() {
        jlptLevelsTableView.register(JLPTLevelTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        jlptLevelsTableView.dataSource = self
        jlptLevelsTableView.delegate = self
        
        view.addSubview(jlptLevelsTableView)
        NSLayoutConstraint.activate([
            jlptLevelsTableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            jlptLevelsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            jlptLevelsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        jlptLevelsTableView.layer.borderColor = borderColor.cgColor
        jlptLevelsTableView.rowHeight = 44
    }
    
    private func setUpStartQuizButton() {
        view.addSubview(startQuizButton)
        startQuizButton.titleLabel?.textColor = textColor
        startQuizButton.backgroundColor = contentBackgroundColor
        
        NSLayoutConstraint.activate([
            startQuizButton.topAnchor.constraint(equalTo: jlptLevelsTableView.bottomAnchor, constant: 10),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        startQuizButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        startQuizButton.layer.cornerRadius = startQuizButton.titleLabel!.frame.height / 2
        startQuizButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
        startQuizButton.layer.borderColor = borderColor.cgColor
    }
    
    // MARK: Interactivity
    
    @objc func startQuiz() {
        var levels:[Int] = []
        for i in 0..<includedLevels.count {
            if includedLevels[i] {
                levels.append(includedLevels.count-i)
            }
        }
        print(levels)
        if levels.count == 0 {
            return
        }
        
        let start = DispatchTime.now()
        let quiz = KanjiQuiz(withContext: context, ofLength: quizLength, jlptLevels: levels)
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print(timeInterval)
        
        let quizViewController = KanjiQuizViewController(withKanjiQuiz: quiz)
        navigationController?.pushViewController(quizViewController, animated: true)
    }
    
    // MARK: UITableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let levels = jlptLevels else {
            return 0
        }
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let levels = jlptLevels, let jlptLevelCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? JLPTLevelTableViewCell else {
            return UITableViewCell()
        }
        jlptLevelCell.load(withText: levels[indexPath.row], forViewController: self)
        jlptLevelCell.tintColor = textColor
        jlptLevelCell.backgroundColor = contentBackgroundColor
        return jlptLevelCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = jlptLevelsTableView.cellForRow(at: indexPath) else {
            return
        }
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            includedLevels[indexPath.row] = false
        } else {
            cell.accessoryType = .checkmark
            includedLevels[indexPath.row] = true
        }
        tableView.reloadData()
    }
    
    // MARK: Properties
        
    private let jlptLevelsTableView: JLPTLevelsTableView = {
        let tableView = JLPTLevelsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 2
        return tableView
    }()
    
    private let startQuizButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Start Quiz", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.layer.borderWidth = 2
        return button
    }()
    
    private var jlptLevels: [String]? = ["N5", "N4", "N3", "N2", "N1"]
    private var includedLevels = [false, false, false, false, false]
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

private let quizLength = 10
