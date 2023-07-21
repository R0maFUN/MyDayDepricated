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
    }
    
    public private(set) var sectionsViewModel: SectionsViewModel
    public private(set) var notificationsViewModel: NotificationsViewModel
}
