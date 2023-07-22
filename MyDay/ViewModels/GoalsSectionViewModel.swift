//
//  GoalsSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class GoalsSectionsManager: SectionsManager {
    
    override init(minDate: Date, maxDate: Date) {
        super.init(minDate: minDate, maxDate: maxDate)
        
        self.title = "Goals"
        self.addActionTitle = "Note"
    }
}

class GoalsSectionViewModel: SectionViewModel {

}

class GoalsItemViewModel: SectionItemViewModel {
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }

    public private(set) var editDate: Date = Date()
}
