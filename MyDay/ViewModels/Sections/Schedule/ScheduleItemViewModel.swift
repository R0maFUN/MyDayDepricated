//
//  ScheduleItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

class ScheduleItemViewModel: SectionItemViewModelManagedByRealm {
    
    // MARK: - Init
    init() {
        super.init(title: "", date: Date())
    }
    
    init(title: String, description: String = "", startDate: Date, endDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)
        
        self.startDate = startDate
        self.endDate = endDate
    }
    
    convenience init(realmObject: ScheduleItemRealmObject) {
        self.init(title: realmObject.title, description: realmObject.desc, startDate: realmObject.startDate, endDate: realmObject.endDate, date: realmObject.date)
        
        self.id = realmObject.id
    }
    
    // MARK: - Public Methods
    public func setStartDate(date: Date) {
        self.startDate = date
        
        self.updateRealm()
    }
    
    public func setEndDate(date: Date) {
        self.endDate = date
        
        self.updateRealm()
    }
    
    override func accept(_ updater: SectionRealmItemsUpdater) {
        updater.visit(self)
    }
    
    public func toRealmObject() -> ScheduleItemRealmObject {
        if realmObject != nil {
            return realmObject!
        }
        
        let object = ScheduleItemRealmObject()
        object.title = self.title
        object.desc = self.description
        object.date = self.date
        object.startDate = self.startDate
        object.endDate = self.endDate
        object.id = self.id
        
        self.realmObject = object
        return object
    }
    
    public private(set) var startDate: Date = Date()
    public private(set) var endDate: Date = Date()
    
    private var realmObject: ScheduleItemRealmObject?
}
