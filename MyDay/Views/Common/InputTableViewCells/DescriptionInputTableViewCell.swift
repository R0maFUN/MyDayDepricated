//
//  DescriptionInputTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation
import UIKit

class DescriptionInputTableViewCell: InputTableViewCell<DescriptionModel> {
    static let reuseIdentifier = "DescriptionInputTableViewCell"
    
    public func configure(with model: DescriptionModel) {
        self.value = model
        
        self.value!.onTextChanged { text in
            self.valueChanged()
            
            self.textView.text = text
        }
        
        self.textView.text = model.text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        textView.delegate = self
        
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.tintColor = .label
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = .clear
        
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    internal var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
}
