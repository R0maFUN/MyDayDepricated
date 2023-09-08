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
        
        self.textView.text = model.text
        self.prevLinesCount = self.textView.numberOfLines()
        
        self.value!.onTextChanged { text in
            self.valueChanged()
            
            self.textView.text = text
            
            if self.textView.numberOfLines() != self.prevLinesCount {
                self.linesCountUpdated()
                self.prevLinesCount = self.textView.numberOfLines()
            }
        }
    }
    
    public func onLinesCountUpdated(_ handler: @escaping () -> Void) {
        self.linesCountUpdatedHandlers.append(handler)
    }
    
    private func linesCountUpdated() {
        self.linesCountUpdatedHandlers.forEach { $0() }
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
    
    override func prepareForReuse() {
        self.linesCountUpdatedHandlers = []
    }
    
    internal var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    private var linesCountUpdatedHandlers: [() -> Void] = []
    
    private var prevLinesCount = 0
}
