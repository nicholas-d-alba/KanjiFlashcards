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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "LS", style: .plain, target: nil, action: nil)
        
        let start = DispatchTime.now()
        
        let dataManager = PersistentDataManager(context: context)
        dataManager.setUpCoreDataIfNeeded()

        print("Data has been set up.")

        print(dataManager.loadKanji().count)
        print(dataManager.loadKanjiResources().count)

        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print(timeInterval)
    
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
        view.backgroundColor = ColorPalette.backgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        setUpTitleLabel()
        setUpTableView()
        setUpStartQuizButton()
    }
    
    private func setUpTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
        jlptLevelsTableView.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
    }
    
    private func setUpStartQuizButton() {
        view.addSubview(startQuizButton)
        startQuizButton.titleLabel?.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        startQuizButton.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        
        NSLayoutConstraint.activate([
            startQuizButton.topAnchor.constraint(equalTo: jlptLevelsTableView.bottomAnchor, constant: 10),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        startQuizButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        startQuizButton.layer.cornerRadius = startQuizButton.titleLabel!.frame.height / 2
        startQuizButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
        startQuizButton.layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
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
        let quiz = KanjiQuiz(withContext: context, ofLength: 10, jlptLevels: levels)
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
        jlptLevelCell.load(withText: levels[indexPath.row])
        jlptLevelCell.tintColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        jlptLevelCell.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.text = "Level Selection"
        return label
    }()
        
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
    private var includedLevels = [true, false, false, false, false]
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
