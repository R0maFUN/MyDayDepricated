//
//  SectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation
import RealmSwift

protocol SectionCreator {
    associatedtype Input
    associatedtype Output: SectionViewModel
    static func create(config: Input) -> Output
}

class SectionViewModel: SectionCreator {
    
    enum Unforgivable {
        case base
        case schedule
        case notes
        case reminders
        case goals
    }
    
    required init(date: DateModel) {
        self.date = date
    }
    
    public func fillWithCommonItems() {
        
    }
    
    public class func create(config: DateModel) -> SectionViewModel {
        return SectionViewModel(date: config)
    }
    
    public func add(_ item: SectionItemViewModelManagedByRealm) {
        self.items.append(item)
        
        item.updateRealm()
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public func update(_ item: SectionItemViewModelManagedByRealm) {
        if !self.items.contains(where: { $0.id == item.id }) {
            add(item)
            return
        }
        
        item.updateRealm()
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public func update() {
        
    }
    
    public func onItemsChanged(_ handler: @escaping () -> Void) {
        onItemsChangedHandlers.append(handler)
    }
    
    public internal(set) var items: [SectionItemViewModelManagedByRealm] = []
    public internal(set) var date: DateModel
    
    public class func type() -> Unforgivable {
        return .base
    }
    
    internal var onItemsChangedHandlers: [() -> Void] = []
}
