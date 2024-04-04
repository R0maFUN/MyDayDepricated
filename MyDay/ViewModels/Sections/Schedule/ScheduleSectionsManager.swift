//
//  ScheduleSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

final class ScheduleSectionsManager: SectionsManager<ScheduleSectionViewModel> {
    
    private enum SettingsKeys {
        static let wakeUpTime = "commonWakeUpTime"
        static let fallAsleepTime = "commonFallAsleepTime"
    }
    
    override init(visibleDates: [DateModel]) {
        self.commonWakeUpTime = UserDefaults.standard.object(forKey: SettingsKeys.wakeUpTime) as? Date ?? Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!
        self.commonFallAsleepTime = UserDefaults.standard.object(forKey: SettingsKeys.fallAsleepTime) as? Date ?? Calendar.current.date(bySettingHour: 23, minute: 30, second: 0, of: Date())!
        
        super.init(visibleDates: visibleDates)
        
        self.title = "Schedule"
        self.addActionTitle = "Action"
    }
    
    public func setWakeUpTime(_ value: Date) {
        self.commonWakeUpTime = value
        UserDefaults.standard.setValue(value, forKey: SettingsKeys.wakeUpTime)
    }
    
    public func setFallAsleepTime(_ value: Date) {
        self.commonFallAsleepTime = value
        UserDefaults.standard.setValue(value, forKey: SettingsKeys.fallAsleepTime)
    }
    
    public private(set) var commonWakeUpTime: Date
    public private(set) var commonFallAsleepTime: Date
}
