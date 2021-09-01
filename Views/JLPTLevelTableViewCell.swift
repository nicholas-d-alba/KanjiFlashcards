//
//  JLPTLevelTableViewCell.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 7/27/21.
//

import UIKit

class JLPTLevelTableViewCell: UITableViewCell {

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI
    
    func load(withText text: String, numMastered: Int, numTotal: Int, forViewController viewController: UIViewController) {
        levelLabel.text = text
        progressLabel.text = "\(numMastered)/\(numTotal) mastered"
        contentView.backgroundColor = viewController.contentBackgroundColor
        levelLabel.textColor = viewController.textColor
        progressLabel.textColor = viewController.textColor
        layer.borderColor = viewController.borderColor.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpUI() {
        contentView.addSubview(levelLabel)
        contentView.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            levelLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            levelLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressLabel.firstBaselineAnchor.constraint(equalTo: levelLabel.firstBaselineAnchor),
            progressLabel.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 8)
        ])
        
        layer.borderWidth = 0.5
    }
    
    // MARK: Properties
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
}
