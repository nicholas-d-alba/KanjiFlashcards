//
//  ViewController.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 6/15/21.
//

import CoreData
import UIKit

class JLPTSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    // MARK: ViewController Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadKanji()
        jlptLevelsTableView.reloadData()
    }
    
    
    // MARK: UI Set-Up
    
    private func setUpUI() {
        view.backgroundColor = backgroundColor
        setUpTableView()
        setUpPickerView()
        setUpStartQuizButton()
        setUpBar()
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
        jlptLevelsTableView.backgroundColor = backgroundColor
        jlptLevelsTableView.layer.borderColor = borderColor.cgColor
        jlptLevelsTableView.rowHeight = 44
    }
    
    private func setUpPickerView() {
        view.addSubview(quizLengthLabel)
        quizLengthLabel.textColor = textColor
        NSLayoutConstraint.activate([
            quizLengthLabel.topAnchor.constraint(equalTo: jlptLevelsTableView.bottomAnchor, constant: 10),
            quizLengthLabel.leadingAnchor.constraint(equalTo: jlptLevelsTableView.leadingAnchor),
            quizLengthLabel.widthAnchor.constraint(equalToConstant: quizLengthLabel.intrinsicContentSize.width)
        ])
    
        view.addSubview(quizLengthTextField)
        quizLengthTextField.delegate = self
        quizLengthTextField.backgroundColor = contentBackgroundColor
        quizLengthTextField.layer.borderColor = borderColor.cgColor
        quizLengthTextField.textColor = textColor
        
        NSLayoutConstraint.activate([
            quizLengthTextField.leadingAnchor.constraint(equalTo: quizLengthLabel.trailingAnchor, constant: 8),
            quizLengthTextField.firstBaselineAnchor.constraint(equalTo: quizLengthLabel.firstBaselineAnchor),
            quizLengthTextField.trailingAnchor.constraint(equalTo: jlptLevelsTableView.trailingAnchor),
        ])
        
        quizLengthPickerView.dataSource = self
        quizLengthPickerView.delegate = self
        
        quizLengthTextField.inputView = quizLengthPickerView
        quizLengthPickerView.isHidden = true
        quizLengthPickerView.selectRow(5, inComponent: 0, animated: false)
    }
    
    private func setUpStartQuizButton() {
        view.addSubview(startQuizButton)
        startQuizButton.titleLabel?.textColor = textColor
        startQuizButton.backgroundColor = contentBackgroundColor
        
        NSLayoutConstraint.activate([
            startQuizButton.topAnchor.constraint(equalTo: quizLengthLabel.bottomAnchor, constant: 10),
            startQuizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        startQuizButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        startQuizButton.layer.cornerRadius = startQuizButton.titleLabel!.frame.height / 2
        startQuizButton.layer.borderColor = borderColor.cgColor
        startQuizButton.addTarget(self, action: #selector(startQuiz), for: .touchUpInside)
    }
    
    private func setUpBar() {
        let barButtonItem = UIBarButtonItem(title: "LS", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        navigationItem.title = "Level Selection"
    }
    
    private func loadKanji() {
        kanji = [[], [], [], [], []]
        let dataManager = PersistentDataManager(context: context)
        let allKanji = dataManager.loadKanji()
        for character in allKanji {
            let level = Int(character.jlpt)
            kanji[5-level].append(character)
        }
    }
    
    // MARK: Interactivity
    
    @objc func startQuiz() {
        var levels:[Int] = []
        for i in 0..<includedLevels.count {
            if includedLevels[i] {
                levels.append(includedLevels.count-i)
            }
        }
        guard levels.count > 0 else {
            let alert = UIAlertController(title: "No Levels Selected", message: "Tap on the cells of the table to select kanji levels.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var selectedKanji:[Kanji] = []
        for level in levels {
            selectedKanji.append(contentsOf: kanji[5-level])
        }
        
        let quiz = KanjiQuiz(withContext: context, ofLength: quizLength, kanji: selectedKanji)
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
        let mastered = kanji[indexPath.row].filter{$0.isMastered}.count
        let total = kanji[indexPath.row].count
        jlptLevelCell.load(withText: levels[indexPath.row], numMastered: mastered, numTotal: total, forViewController: self)
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
    
    // MARK: UIPickerView Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quizLengthValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(quizLengthValues[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quizLengthTextField.text = "\(quizLengthValues[row])"
        quizLengthTextField.endEditing(true)
        quizLength = quizLengthValues[row]
    }

    
    // MARK: UITextField Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        quizLengthPickerView.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        quizLengthPickerView.isHidden = true
    }
    
    // MARK: Properties
        
    private let jlptLevelsTableView: JLPTLevelsTableView = {
        let tableView = JLPTLevelsTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 2
        return tableView
    }()
    
    private let quizLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Number of Kanji: "
        return label
    }()
    
    private let quizLengthTextFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let quizLengthTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.layer.borderWidth = 1.0
        textField.textAlignment = .center
        textField.text = "10"
        return textField
    }()
    
    private let quizLengthPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
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
    private var kanji: [[Kanji]] = [[], [], [], [], []]
    private var includedLevels = [false, false, false, false, false]
    private let cellReuseIdentifier = "cellReuseIdentifier"
    
    private var quizLength = 10
    private let quizLengthValues = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
