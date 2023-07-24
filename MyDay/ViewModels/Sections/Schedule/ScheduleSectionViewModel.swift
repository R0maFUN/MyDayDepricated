//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class ScheduleSectionViewModel: SectionViewModel {
    
    override public func add(_ item: SectionItemViewModel) {
        guard let item = item as? ScheduleItemViewModel else { return }
        
        super.add(item)
        
        let sectionsRealmManager = SectionsRealmManager<ScheduleItemViewModel>()
        sectionsRealmManager.update(item: item)
    }
    
    public private(set) var inProgressItems: [ScheduleItemViewModel] = []
    public private(set) var nextItems: [ScheduleItemViewModel] = []
}
