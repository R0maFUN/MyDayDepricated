//
//  RemindersSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class RemindersSectionViewModel: SectionViewModel {
    override init() {
        super.init()
        
        self.title = "Reminders"
        self.addActionTitle = "Reminder"
    }
}
