//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class ScheduleSectionsManager: SectionsManager {
    
    override init(minDate: Date, maxDate: Date) {
        super.init(minDate: minDate, maxDate: maxDate)
        
        self.title = "Schedule"
        self.addActionTitle = "Action"
        
        initialize()
    }
    
    override func initialize() {
        let calendar = Calendar.current

        // TODO: Refactor
        // Replace the hour (time) of both dates with 00:00
        var date1 = calendar.startOfDay(for: self.minDate)
        let date2 = calendar.startOfDay(for: self.maxDate)

        while date1 <= date2 {
            let section = ScheduleSectionViewModel(date: date1)
            section.add(ScheduleItemViewModel(title: "Test 123", startDate: Date(), endDate: Date(), date: date1))
            section.add(ScheduleItemViewModel(title: "Test 456", startDate: Date(), endDate: Date(), date: date1))
            self.sections.value![getSectionKeyFrom(date: date1)] = section
            date1 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        }
    }
}

class ScheduleSectionViewModel: SectionViewModel {
    public private(set) var inProgressItems: [ScheduleItemViewModel] = []
    public private(set) var nextItems: [ScheduleItemViewModel] = []
}

class ScheduleItemViewModel: SectionItemViewModel {
    
    init() {
        super.init(title: "", date: Date())
    }
    
    init(title: String, description: String = "", startDate: Date, endDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)
        
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public func setStartDate(date: Date) {
        self.startDate = date
    }
    
    public func setEndDate(date: Date) {
        self.endDate = date
    }
    
    public private(set) var startDate: Date = Date()
    public private(set) var endDate: Date = Date()
}
