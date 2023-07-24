//
//  SectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import Foundation

func getSectionKeyFrom(date: DateModel) -> Int {
    return 31 * date.monthInt + date.day
//    let components = Calendar.current.dateComponents([.month, .day], from: date)
//    return 31 * components.month! + components.day!
}

class SectionsManager {
    
    init(minDate: DateModel, maxDate: DateModel) {
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    public func activate() {
        self.isActive.value = true
    }
    
    public func deactivate() {
        self.isActive.value = false
    }
    
    public func setDate(date: DateModel) {
        self.currentDate = date
    }
    
    public func getSection(by date: DateModel) -> SectionViewModel? {
        return self.sections.value![getSectionKeyFrom(date: date)]
    }
    
    public func add(section: SectionViewModel) {
        self.sections.value![getSectionKeyFrom(date: section.date)] = section
    }
    
    public func initialize() {
        
    }
    
    public internal(set) var title: String = ""
    public internal(set) var addActionTitle: String = ""
    public internal(set) var isActive: PropertyBinding<Bool> = PropertyBinding<Bool>(false)
    public internal(set) var sections: PropertyBinding<[Int: SectionViewModel]> = PropertyBinding<[Int: SectionViewModel]>([:])
    public internal(set) var currentSection: PropertyBinding<SectionViewModel> = PropertyBinding()
    
    internal var minDate: DateModel
    internal var maxDate: DateModel
    
    private var currentDate: DateModel? {
        didSet {
            self.currentSection.value = self.sections.value![getSectionKeyFrom(date: currentDate!)]
        }
    }
}
