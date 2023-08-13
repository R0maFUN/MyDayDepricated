//
//  MainViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class MainViewModel {
    
    private enum SettingsKeys {
        static let wakeUpTime = "wakeUpTime"
        static let fallAsleepTime = "fallAsleepTime"
    }
    
    init() {
        self.notificationsViewModel = NotificationsViewModel()
        
        self.wakeUpTime = UserDefaults.standard.object(forKey: SettingsKeys.wakeUpTime) as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        self.fallAsleepTime = UserDefaults.standard.object(forKey: SettingsKeys.fallAsleepTime) as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: Date())!
        
        let currentDate = Date()
        let datePrevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let dateNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        
        var date1 = Calendar.current.startOfDay(for: datePrevMonth)
        let date2 = Calendar.current.startOfDay(for: dateNextMonth)

        while date1 <= date2 {
            visibleDates.append(DateModel(date: date1))
            date1 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        }
        
        self.sectionsViewModel = SectionsViewModel(visibleDates: visibleDates, currentDate: DateModel(date: currentDate))
        
        self.setCurrentDate(to: self.getVisibleDateModel(by: currentDate)!)
        
        self.currentDate.onChanged {
            for manager in self.sectionsViewModel.sectionManagers {
                manager.setDate(date: self.currentDate.value!)
            }
        }
    }
    
    public func setCurrentDate(to date: DateModel) {
        self.currentDate.value?.selected = false
        self.currentDate.value = date
        self.currentDate.value?.selected = true
    }
    
    public func setWakeUpTime(_ value: Date) {
        self.wakeUpTime = value
        UserDefaults.standard.setValue(value, forKey: SettingsKeys.wakeUpTime)
    }
    
    public func setFallAsleepTime(_ value: Date) {
        self.fallAsleepTime = value
        UserDefaults.standard.setValue(value, forKey: SettingsKeys.fallAsleepTime)
    }
    
    public func getVisibleDateModel(by date: Date) -> DateModel? {
        let searchingDay = Calendar.current.component(.day, from: date)
        let searchingMonth = Calendar.current.component(.month, from: date)
        
        return self.visibleDates.first(where: { dateModel in
            return dateModel.monthInt == searchingMonth && dateModel.day == searchingDay
        })
    }
    
    public func getIndexOfCurrentDate() -> Int? {
        return self.visibleDates.firstIndex(where: { dateModel in
            dateModel.day == currentDate.value!.day && dateModel.monthInt == currentDate.value!.monthInt
        })
    }
    
    public private(set) var sectionsViewModel: SectionsViewModel
    public private(set) var notificationsViewModel: NotificationsViewModel
    public private(set) var currentDate: PropertyBinding<DateModel> = PropertyBinding<DateModel>()
    public private(set) var visibleDates: [DateModel] = []
    
    public private(set) var wakeUpTime: Date
    public private(set) var fallAsleepTime: Date
}
