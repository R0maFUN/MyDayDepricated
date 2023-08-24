//
//  GoalsSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class GoalsSectionViewModel: SectionViewModel {
    override public class func type() -> Unforgivable {
        return .goals
    }
    
    override public class func create(config: DateModel) -> SectionViewModel {
        return GoalsSectionViewModel(date: config)
    }
    
    override public func fillWithCommonItems() {
        self.add(GoalsItemViewModel(descriptions: ("Make", "push-ups"), goalValue: 150, currentValue: 0, stepValue: 5, date: self.date.date, type: .Counter))
    }
    
//    override public func add(_ item: SectionItemViewModelManagedByRealm) {
//        super.add(item)
//        
//        if let item = item as? GoalsItemViewModel {
//            item.onCurrentValueChanged {
//                self.onItemsChangedHandlers.forEach { $0() }
//            }
//        }
//    }
}
