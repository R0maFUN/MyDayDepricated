//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class ScheduleSectionsManager: SectionsManager {
    
    override init(minDate: DateModel, maxDate: DateModel) {
        super.init(minDate: minDate, maxDate: maxDate)
        
        self.title = "Schedule"
        self.addActionTitle = "Action"
        
        initialize()
    }
    
    init(visibleDates: [DateModel]) {
        super.init(minDate: visibleDates.first!, maxDate: visibleDates.last!)
        
        self.title = "Schedule"
        self.addActionTitle = "Action"
        
        initialize(visibleDates: visibleDates)
    }
    
    override func initialize() {
        //let sections = restore()
    }
    
    func initialize(visibleDates: [DateModel]) {
        let restoredSections = restore()
        for dateModel in visibleDates {
            if !restoredSections.keys.contains(where: { key in
                return key == dateModel
            }) {
                let section = ScheduleSectionViewModel(date: dateModel)
                section.add(ScheduleItemViewModel(title: "Test \(dateModel.month)", startDate: Date(), endDate: Date(), date: dateModel.date))
                section.add(ScheduleItemViewModel(title: "Test \(dateModel.day)", startDate: Date(), endDate: Date(), date: dateModel.date))
                add(section: section)
            }
        }
    }
    
    func restore() -> [DateModel:ScheduleSectionViewModel] {
        return [:]
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
        
        self.setDescription(description: "Description")
        
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
