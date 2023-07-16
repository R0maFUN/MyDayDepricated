//
//  SectionsViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class SectionsViewModel {
    
    init() {
        self.sections = [
            ScheduleSectionViewModel(),
            NotesSectionViewModel(),
            RemindersSectionViewModel(),
            GoalsSectionViewModel()
        ]
        
        self.currentSectionIndex.value = 0
        self.currentSection.value = self.sections[self.currentSectionIndex.value!]
        self.currentSection.value?.activate()
    }
    
    public func selectSectionAt(_ index: Int) {
        if index < 0 || index >= self.sections.count {
            return
        }
        
        self.currentSection.value?.deactivate()
        self.currentSectionIndex.value = index
        self.currentSection.value = self.sections[index]
        self.currentSection.value?.activate()
    }
    
    public func select(section: SectionViewModel) {
        guard let index = self.sections.firstIndex(where: { $0.title == section.title }) else { return }
        self.selectSectionAt(index)
    }
    
    public private(set) var sections: [SectionViewModel] = []
    public private(set) var currentSection = PropertyBinding<SectionViewModel>()
    public private(set) var currentSectionIndex = PropertyBinding<Int>()
}
