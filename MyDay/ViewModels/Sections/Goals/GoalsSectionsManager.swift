//
//  GoalsSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation
import UIKit

final class GoalsSectionsManager: SectionsManager<GoalsSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Goals"
        self.addActionTitle = "Goal"
        self.addActionColor = UIColor(named: "GoalsPrimary")!
    }
}
