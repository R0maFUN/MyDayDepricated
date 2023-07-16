//
//  PropertyBinding.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

final class PropertyBinding<T> {
    var value: T? {
        didSet {
            blocks.forEach { block in
                block()
            }
        }
    }
    
    init(_ value: T? = nil) {
        self.value = value
    }
    
    func onChanged(_ block: @escaping () -> Void) {
        blocks.append(block)
    }
    
    private var blocks: [() -> Void] = []
}
