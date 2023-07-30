//
//  InputTableViewCell.swift
//  MyDay
//
//  Created by Рома Балаян on 30.07.2023.
//

import Foundation
import UIKit

class InputTableViewCell<T>: UITableViewCell {
    
    public func onValueChanged(_ handler: @escaping (_ value: T) -> Void) {
        self.onValueChangedHandlers.append(handler)
    }
    
    public internal(set) var value: T? {
        didSet {
            valueChanged()
        }
    }
    
    internal func valueChanged() {
        self.onValueChangedHandlers.forEach { $0(value!) }
    }
    
    private var onValueChangedHandlers: [(_ value: T) -> Void] = []
    
}
