//
//  DescriptionModel.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation

class DescriptionModel {
    static let placeholder = "Description"
    
    init() {
        
    }
    
    init(text: String) {
        self.text = text.isEmpty ? DescriptionModel.placeholder : text
    }
    
    public func setText(_ text: String) {
        self.text = text
        
        self.textChanged()
    }
    
    public func onTextChanged(_ handler: @escaping (_ text: String) -> Void) {
        self.textChangedHandlers.append(handler)
    }
    
    private func textChanged() {
        self.textChangedHandlers.forEach { $0(self.text) }
    }
    
    public func isPlaceholderVisible() -> Bool {
        return self.text == DescriptionModel.placeholder
    }
    
    public private(set) var id: String = UUID().uuidString
    public private(set) var text: String = placeholder
    
    private var textChangedHandlers: [(_ text: String) -> Void] = []
}
