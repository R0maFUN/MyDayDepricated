//
//  SectionItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

class SectionItemViewModel {
    
    init(title: String, description: String = "", date: Date) {
        self.title = title
        self.description = description
        self.date = date
    }
    
    public func setTitle(title: String) {
        self.title = title
    }
    
    public func setDescription(description: String) {
        self.description = description
    }
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    public private(set) var title: String = ""
    public internal(set) var description: String = ""
    public private(set) var date: Date
    
    public internal(set) var id: String = UUID().uuidString
}
