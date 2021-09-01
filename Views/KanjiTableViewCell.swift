//
//  KanjiTableViewCell.swift
//  Kanji Kitsune
//
//  Created by Nicholas Alba on 8/19/21.
//

import UIKit

class KanjiTableViewCell: UITableViewCell {

    // MARK: Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: UI Set-Up
    
    func loadDetails(forKanji kanji: Kanji) {
        guard let name = kanji.name, let meanings = kanji.meanings else {return}
        nameLabel.text = name
        meaningsLabel.text = meanings.joined(separator: ", ")
    }
    
    func setColors(forViewController viewController: UIViewController) {
        contentView.backgroundColor = viewController.contentBackgroundColor
        contentView.layer.borderColor = viewController.borderColor.cgColor
        nameLabel.textColor = viewController.textColor
        meaningsLabel.textColor = viewController.textColor
    }
    
    private func setUpUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(meaningsLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.25),
            meaningsLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            meaningsLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            meaningsLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            meaningsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.layer.borderWidth = 0.5
    }
    
    
    // MARK: Properties
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let meaningsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
}
