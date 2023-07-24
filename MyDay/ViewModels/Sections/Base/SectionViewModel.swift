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
    
    public func update() {
        
    }
    
    public func onItemsChanged(_ handler: @escaping () -> Void) {
        onItemsChangedHandlers.append(handler)
    }
    
    public internal(set) var items: [SectionItemViewModel] = []
    public internal(set) var date: DateModel
    
    internal var onItemsChangedHandlers: [() -> Void] = []
}
