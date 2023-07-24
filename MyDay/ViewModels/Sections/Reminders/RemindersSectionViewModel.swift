//
//  RemindersSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class RemindersSectionsManager: SectionsManager {
    
    override init(minDate: DateModel, maxDate: DateModel) {
        super.init(minDate: minDate, maxDate: maxDate)
        
        self.title = "Reminders"
        self.addActionTitle = "Reminder"
    }
}

class RemindersSectionViewModel: SectionViewModel {

}

class RemindersItemViewModel: SectionItemViewModel {
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }

    public private(set) var editDate: Date = Date()
}
