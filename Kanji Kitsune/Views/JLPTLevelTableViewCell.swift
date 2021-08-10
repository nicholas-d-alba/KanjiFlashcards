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
    
    func load(withText text: String) {
        label.text = text
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpUI() {
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
        
        contentView.backgroundColor = ColorPalette.contentBackgroundColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
        label.textColor = ColorPalette.textColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle)
    
        layer.borderColor = ColorPalette.borderColor(forUserInterfaceStyle: traitCollection.userInterfaceStyle).cgColor
        layer.borderWidth = 0.5
    }
    
    // MARK: Properties
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
}
