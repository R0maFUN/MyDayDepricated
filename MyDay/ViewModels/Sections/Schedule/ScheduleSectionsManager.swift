//
//  ScheduleSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

final class ScheduleSectionsManager: SectionsManager<ScheduleSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Schedule"
        self.addActionTitle = "Action"
    }
}
