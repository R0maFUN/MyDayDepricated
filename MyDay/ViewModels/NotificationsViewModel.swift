//
//  NotificationsViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import Foundation

class NotificationsViewModel {
    
    init() {
        
    }
    
    public func enable() {
        self.isEnabled.value = true
    }
    
    public func disable() {
        self.isEnabled.value = false
    }
    
    public func notificationsCount() -> Int {
        return (isEnabled.value! ? 1 : 0) * notifications.count
    }
    
    public private(set) var isEnabled: PropertyBinding<Bool> = PropertyBinding(false)
    public private(set) var notifications: [NotificationViewModel] = [NotificationViewModel(title: "Some title"),
                                                                      NotificationViewModel(title: "Some title"),
                                                                      NotificationViewModel(title: "Some title")]
}

class NotificationViewModel {
    
    init(title: String = "", isOn: Bool = false) {
        self.title = title
        self.isOn = isOn
    }
    
    public private(set) var isOn: Bool = false
    public private(set) var title: String = ""
}
