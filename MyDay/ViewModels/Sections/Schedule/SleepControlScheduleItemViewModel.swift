//
//  SleepControlScheduleItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 06.11.2023.
//

import Foundation

// MARK: - SleepControlScheduleItemViewModel
class SleepControlScheduleItemViewModel: ScheduleItemViewModel {
    
    // MARK: - Private Properties
    public private(set) var alarmEnabled: Bool = false
}

// MARK: - WakeUp
class SleepControlWakeUpScheduleItemViewModel: SleepControlScheduleItemViewModel {
    
    private enum Constants {
        static let title = "Wake Up"
        static let description = "Good Morning!"
    }
    
    init(wakeUpDate: Date, date: Date) {
        super.init(title: Constants.title, description: Constants.description, startDate: wakeUpDate, endDate: wakeUpDate, date: date)
    }
}

// MARK: - FallAsleep
class SleepControlFallAsleepScheduleItemViewModel: SleepControlScheduleItemViewModel {
    
    private enum Constants {
        static let title = "Fall Asleep"
        static let description = "Good Night!"
    }
    
    init(fallAsleepDate: Date, date: Date) {
        super.init(title: Constants.title, description: Constants.description, startDate: fallAsleepDate, endDate: fallAsleepDate, date: date)
    }
}
