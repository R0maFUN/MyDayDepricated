//
//  GoalsSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation

final class GoalsSectionsManager: SectionsManager<GoalsSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Goals"
        self.addActionTitle = "Goal"
    }
}
