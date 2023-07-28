//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation
import RealmSwift

final class ScheduleSectionViewModel: SectionViewModel {
    typealias ItemInput = ScheduleItemRealmObject
    
    override public class func type() -> Unforgivable {
        return .schedule
    }
    
    override public func fillWithCommonItems() {
        self.add(ScheduleItemViewModel(title: "Test \(self.date.month)", description: "No Desc", startDate: Date(), endDate: Date(), date: self.date.date))
        self.add(ScheduleItemViewModel(title: "Test \(self.date.day)", description: "No Desc", startDate: Date(), endDate: Date(), date: self.date.date))
    }
    
    func sort() {
        self.items.sort(by: { lhs, rhs in
            if let lhs = lhs as? ScheduleItemViewModel, let rhs = rhs as? ScheduleItemViewModel {
                return lhs.startDate < rhs.startDate
            }
            return false
        })
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    override public class func create(config: DateModel) -> ScheduleSectionViewModel {
        return ScheduleSectionViewModel(date: config)
    }
    
    override func update() {
        self.inProgressItems = []
        self.nextItems = []
        
        self.sort()
        
        let foundLatestTask = false
        for item in self.items {
            if let item = item as? ScheduleItemViewModel {
                if item.startDate < Date() && item.endDate > Date() {
                    self.inProgressItems.append(item)
                }
                
                if item.startDate > Date() && !foundLatestTask {
                    self.nextItems.append(item)
                }
            }
        }
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public private(set) var inProgressItems: [ScheduleItemViewModel] = []
    public private(set) var nextItems: [ScheduleItemViewModel] = []
}

