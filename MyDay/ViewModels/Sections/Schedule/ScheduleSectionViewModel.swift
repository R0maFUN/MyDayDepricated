//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

final class ScheduleSectionViewModel: SectionViewModel {
    
    override public func add(_ item: SectionItemViewModel) {
        guard let item = item as? ScheduleItemViewModel else { return }
        
        super.add(item)
        
        let sectionsRealmManager = SectionsRealmManager<ScheduleItemViewModel>()
        sectionsRealmManager.update(item: item)
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
