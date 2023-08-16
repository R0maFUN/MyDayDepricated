//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation
import RealmSwift
import HealthKit

final class ScheduleSectionViewModel: SectionViewModel {
    typealias ItemInput = ScheduleItemRealmObject
    
    init(date: DateModel, wakeUpTime: Date, fallAsleepTime: Date) {
        self.wakeUpTime = wakeUpTime
        self.fallAsleepTime = fallAsleepTime
        
        super.init(date: date)
    }
    
    required init(date: DateModel) {
        // restore
        self.wakeUpTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        self.fallAsleepTime = Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: Date())!
        
        super.init(date: date)
    }
    
    override public class func type() -> Unforgivable {
        return .schedule
    }
    
    override public func fillWithCommonItems() {
        //requestSleepAuthorization()
        
        self.add(ScheduleItemViewModel(title: "Wake Up", description: "Good Morning!", startDate: self.wakeUpTime, endDate: self.wakeUpTime, date: self.date.date))
        self.add(ScheduleItemViewModel(title: "Fall asleep", description: "Good Night!", startDate: self.fallAsleepTime, endDate: self.fallAsleepTime, date: self.date.date))
    }
    
    func requestSleepAuthorization() {
        let healthStore = HKHealthStore()
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let setType = Set<HKSampleType>(arrayLiteral: sleepType)
            healthStore.requestAuthorization(toShare: setType, read: setType) { (success, error) in
                
                if !success || error != nil {
                    // handle error
                    return
                }
                
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
                
                let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: 3, sortDescriptors: [sortDescriptor]) { (query, tmpResult, error) -> Void in
                    if error != nil {
                        return
                    }
                    
                    var success = false
                    
                    if let result = tmpResult {
                        for item in result {
                            if let sample = item as? HKCategorySample {
                                if sample.value == 0 {
                                    let startDate = sample.startDate
                                    let endDate = sample.endDate
                                    
                                    DispatchQueue.main.async {
                                        self.add(ScheduleItemViewModel(title: "Wake Up", description: "Good Morning!", startDate: startDate, endDate: startDate, date: self.date.date))
                                        self.add(ScheduleItemViewModel(title: "Fall asleep", description: "Good Night!", startDate: endDate, endDate: endDate, date: self.date.date))
                                    }
                                    success = true
                                }
                            }
                        }
                    }
                    
                    if (!success) {
                        DispatchQueue.main.async {
                            self.add(ScheduleItemViewModel(title: "Wake Up", description: "Good Morning!", startDate: self.wakeUpTime, endDate: self.wakeUpTime, date: self.date.date))
                            self.add(ScheduleItemViewModel(title: "Fall asleep", description: "Good Night!", startDate: self.fallAsleepTime, endDate: self.fallAsleepTime, date: self.date.date))
                        }
                        
                    }
                }
                
                healthStore.execute(query)
                
                // handle success
            }
        }
    }
    
    func sort() {
        self.items.sort(by: { lhs, rhs in
            if let lhs = lhs as? ScheduleItemViewModel, let rhs = rhs as? ScheduleItemViewModel {
                return lhs.startDate < rhs.startDate
            }
            return false
        })
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    override public class func create(config: DateModel) -> ScheduleSectionViewModel {
        return ScheduleSectionViewModel(date: config)
    }
    
    override func update() {
        self.inProgressItems = []
        self.nextItems = []
        
        self.sort()
        
        let foundLatestTask = false
        for item in self.items {
            if let item = item as? ScheduleItemViewModel {
                if item.startDate < Date() && item.endDate > Date() {
                    self.inProgressItems.append(item)
                }
                
                if item.startDate > Date() && !foundLatestTask {
                    self.nextItems.append(item)
                }
            }
        }
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public private(set) var inProgressItems: [ScheduleItemViewModel] = []
    public private(set) var nextItems: [ScheduleItemViewModel] = []
    
    private var wakeUpTime: Date
    private var fallAsleepTime: Date
}

