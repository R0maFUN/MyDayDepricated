//
//  TitleInputTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation
import UIKit

class TitleInputTableViewCell: InputTableViewCell<String> {
    static let reuseIdentifier = "TitleInputTableViewCell"
    
    public func configure(with title: String) {
        self.textField.text = title
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        textField.delegate = self
        
        textField.font = .systemFont(ofSize: 20, weight: .semibold)
        textField.placeholder = "Title"
        textField.tintColor = .label
        
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
}
