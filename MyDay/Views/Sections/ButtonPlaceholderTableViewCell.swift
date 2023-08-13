//
//  ButtonPlaceholderTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 13.08.2023.
//

import UIKit

class ButtonPlaceholderTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ButtonPlaceholderTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = NotesColors.primary
        
        self.contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var text: String = "" {
        didSet {
            label.text = text
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .white
        return label
    }()
}
