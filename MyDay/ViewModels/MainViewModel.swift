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
    }
    
    public private(set) var sectionsViewModel: SectionsViewModel
}
