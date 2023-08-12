//
//  TagView.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import UIKit

class TagView: UIView {

    init() {
        super.init(frame: .zero)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum UIConstants {
        static let labelHorizontalInset = 6
        static let labelVerticalInset = 4
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    public var text: String = "" {
        didSet {
            self.label.text = text
        }
    }

}

private extension TagView {
    func initialize() {
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor(rgb: 0xFFC42D)
        
        self.addSubview(label)
        
        label.textAlignment = .center
        
        label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(UIConstants.labelHorizontalInset)
            make.top.bottom.equalToSuperview().inset(UIConstants.labelVerticalInset)
        }
    }
}
