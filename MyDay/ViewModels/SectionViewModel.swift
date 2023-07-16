//
//  SectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class SectionViewModel {
    
    public func activate() {
        self.isActive.value = true
    }
    
    public func deactivate() {
        self.isActive.value = false
    }
    
    public internal(set) var title: String = ""
    public internal(set) var isActive: PropertyBinding<Bool> = PropertyBinding<Bool>(false)
}
