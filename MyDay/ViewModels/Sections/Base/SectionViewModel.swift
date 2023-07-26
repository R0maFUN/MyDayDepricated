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
    
    // TODO: Refactor
    public class func createItem(config: Object) -> SectionItemViewModel? {
        return nil
    }
    
    // TODO: Refactor, class should not know about realm at all
    public class func updateRealmItem(item: SectionItemViewModel) -> Bool {
        return false
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
    
    public class func type() -> Unforgivable {
        return .base
    }
    
    internal var onItemsChangedHandlers: [() -> Void] = []
}
