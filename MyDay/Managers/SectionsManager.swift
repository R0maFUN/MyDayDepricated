//
//  SectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import Foundation

public func getSectionKeyFrom(date: Date) -> Int {
    let components = Calendar.current.dateComponents([.month, .day], from: date)
    return 31 * components.month! + components.day!
}

class SectionsManager {
    
    init(minDate: Date, maxDate: Date) {
        self.minDate = minDate
        self.maxDate = maxDate
    }
    
    public func activate() {
        self.isActive.value = true
    }
    
    public func deactivate() {
        self.isActive.value = false
    }
    
    public func setDate(date: Date) {
        self.currentDate = date
    }
    
    public func getSection(by date: Date) -> SectionViewModel? {
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
    
    internal var minDate: Date = Date()
    internal var maxDate: Date = Date()
    
    private var currentDate: Date = Date() {
        didSet {
            self.currentSection.value = self.sections.value![getSectionKeyFrom(date: currentDate)]
        }
    }
}
