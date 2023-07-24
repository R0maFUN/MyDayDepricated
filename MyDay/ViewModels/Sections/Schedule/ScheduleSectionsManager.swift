//
//  ScheduleSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

final class ScheduleSectionsManager: SectionsManager {
    
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
    
    private func initialize(visibleDates: [DateModel]) {
        let restoredSections = restore()
        
        restoredSections.forEach({ key, value in
            self.add(section: value)
        })
        
        for dateModel in visibleDates {
            if !restoredSections.keys.contains(where: { key in
                return key == dateModel
            }) {
                let section = ScheduleSectionViewModel(date: dateModel)
                section.add(ScheduleItemViewModel(title: "Test \(dateModel.month)", description: "No Desc", startDate: Date(), endDate: Date(), date: dateModel.date))
                section.add(ScheduleItemViewModel(title: "Test \(dateModel.day)", description: "No Desc", startDate: Date(), endDate: Date(), date: dateModel.date))
                add(section: section)
            }
        }
    }
    
    private func restore() -> [DateModel:ScheduleSectionViewModel] {
        let realmManager = SectionsRealmManager<ScheduleItemViewModel>()
        let scheduleItems = realmManager.restore()
        
        var result: [DateModel:ScheduleSectionViewModel] = [:]
        
        for item in scheduleItems {
            let dateModel = DateModel(date: item.date)
            
            if !result.keys.contains(where: { $0.day == dateModel.day && $0.monthInt == dateModel.monthInt }) {
                result[dateModel] = ScheduleSectionViewModel(date: dateModel)
            }
            
            result[dateModel]?.add(item)
        }
        
        return result
    }
}
