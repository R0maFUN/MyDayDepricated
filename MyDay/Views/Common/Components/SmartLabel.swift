//
//  SmartLabel.swift
//  MyDay
//
//  Created by Рома Балаян on 12.08.2023.
//

import UIKit

class SmartLabel: UILabel {

    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var text: String? {
        didSet {
            // font size = calculate()
        }
    }
    
    private func calculate() {
        
    }
    
    public var maxFontSize: CGFloat = 0.0
    public var bigFontSize: CGFloat = 0.0
    public var mediumFontSize: CGFloat = 0.0
    public var smallFontSize: CGFloat = 0.0
    public var minFontSize: CGFloat = 0.0
    
}
