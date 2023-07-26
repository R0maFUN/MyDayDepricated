//
//  RemindersSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class RemindersSectionsManager: SectionsManager<RemindersSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Reminders"
        self.addActionTitle = "Reminder"
    }
}

class RemindersSectionViewModel: SectionViewModel {
    override public class func type() -> Unforgivable {
        return .reminders
    }
}

class RemindersItemViewModel: SectionItemViewModel {
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }

    public private(set) var editDate: Date = Date()
}
