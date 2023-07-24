//
//  SectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class SectionViewModel {
    
    init(date: DateModel) {
        self.date = date
    }
    
    public func add(_ item: SectionItemViewModel) {
        self.items.append(item)
        
        // save to database
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public func onItemsChanged(_ handler: @escaping () -> Void) {
        onItemsChangedHandlers.append(handler)
    }
    
    public internal(set) var items: [SectionItemViewModel] = []
    public internal(set) var date: DateModel
    
    private var onItemsChangedHandlers: [() -> Void] = []
}

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
    public private(set) var description: String = ""
    public private(set) var date: Date
}
