//
//  SectionsViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class SectionsViewModel {
    
    init() {
        // TODO: Refactor
        let currentDate = Date()
        let dateJune = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let dateAug = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        self.sectionManagers = [
            ScheduleSectionsManager(minDate: dateJune, maxDate: dateAug),
            NotesSectionsManager(minDate: dateJune, maxDate: dateAug),
            RemindersSectionsManager(minDate: dateJune, maxDate: dateAug),
            GoalsSectionsManager(minDate: dateJune, maxDate: dateAug)
        ]
        
        for manager in self.sectionManagers {
            manager.setDate(date: Calendar.current.startOfDay(for: Date()))
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
    
    public func select(section: SectionsManager) {
        guard let index = self.sectionManagers.firstIndex(where: { $0.title == section.title }) else { return }
        self.selectSectionAt(index)
    }
    
    public private(set) var sectionManagers: [SectionsManager] = []
    public private(set) var currentSectionManager = PropertyBinding<SectionsManager>()
    public private(set) var currentSectionManagerIndex = PropertyBinding<Int>()
}
