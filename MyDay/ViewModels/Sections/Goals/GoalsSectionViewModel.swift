//
//  GoalsSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

final class GoalsSectionsManager: SectionsManager<GoalsSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Goals"
        self.addActionTitle = "Note"
    }
}

class GoalsSectionViewModel: SectionViewModel {
    override public class func type() -> Unforgivable {
        return .goals
    }
}

class GoalsItemViewModel: SectionItemViewModel {
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }

    public private(set) var editDate: Date = Date()
}
