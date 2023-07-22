//
//  MainViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class MainViewModel {
    
    init() {
        self.sectionsViewModel = SectionsViewModel()
        self.notificationsViewModel = NotificationsViewModel()
        
        let currentDate = Date()
        let datePrevMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let dateNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
        
        var date1 = Calendar.current.startOfDay(for: datePrevMonth)
        let date2 = Calendar.current.startOfDay(for: dateNextMonth)

        while date1 <= date2 {
            visibleDates.append(DateModel(date: date1))
            date1 = Calendar.current.date(byAdding: .day, value: 1, to: date1)!
        }
        
        self.setCurrentDate(to: self.getVisibleDateModel(by: currentDate)!)
    }
    
    public func setCurrentDate(to date: DateModel) {
        self.currentDate.value?.selected = false
        self.currentDate.value = date
        self.currentDate.value?.selected = true
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
}
