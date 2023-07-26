//
//  SectionsViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class SectionsViewModel {
    
    init(visibleDates: [DateModel], currentDate: DateModel) {

        self.sectionManagers = [
            ScheduleSectionsManager(visibleDates: visibleDates),
            NotesSectionsManager(visibleDates: visibleDates),
            RemindersSectionsManager(visibleDates: visibleDates),
            GoalsSectionsManager(visibleDates: visibleDates)
        ]
        
        for manager in self.sectionManagers {
            manager.setDate(date: currentDate)
        }
        
        self.currentSectionManagerIndex.value = 0
        self.currentSectionManager.value = self.sectionManagers[self.currentSectionManagerIndex.value!]
        self.currentSectionManager.value?.activate()
    }
    
    public func selectSectionAt(_ index: Int) {
        if index < 0 || index >= self.sectionManagers.count {
            return
        }
        
        self.currentSectionManager.value?.deactivate()
        self.currentSectionManagerIndex.value = index
        self.currentSectionManager.value = self.sectionManagers[index]
        self.currentSectionManager.value?.activate()
    }
    
    public func select(section: ISectionsManager) {
        guard let index = self.sectionManagers.firstIndex(where: { $0.title == section.title }) else { return }
        self.selectSectionAt(index)
    }
    
    public private(set) var sectionManagers: [ISectionsManager] = []
    public private(set) var currentSectionManager = PropertyBinding<ISectionsManager>()
    public private(set) var currentSectionManagerIndex = PropertyBinding<Int>()
}
