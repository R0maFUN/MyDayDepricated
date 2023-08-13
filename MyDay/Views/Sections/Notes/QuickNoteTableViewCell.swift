//
//  QuickNoteTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import UIKit

class QuickNoteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "QuickNoteTableViewCell"
    
    public func configure(with viewModel: NotesItemViewModel) {
        textField.text = viewModel.title
        
        if !viewModel.title.isEmpty {
            self.iconButton.isHidden = true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        textField.text = ""
        iconButton.isHidden = false
    }
    
    private var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Quick Note",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 16, weight: .semibold)
        return textField
    }()
    
    private var iconButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        //button.setImage(UIImage(systemName: "plus")!, for: .normal)
        button.setImage(UIImage(systemName: "character.cursor.ibeam")!, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 20

        return button
    }()
    
}

private extension QuickNoteTableViewCell {
    func initialize() {
        self.backgroundColor = .darkGray
        
        self.addSubview(textField)
        self.addSubview(iconButton)
        
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.top.bottom.equalToSuperview()
        }
        
        iconButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
