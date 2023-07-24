//
//  NotesSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation

class NotesSectionsManager: SectionsManager {
    
    override init(minDate: DateModel, maxDate: DateModel) {
        super.init(minDate: minDate, maxDate: maxDate)
        
        self.title = "Notes"
        self.addActionTitle = "Note"
    }
}

class NotesSectionViewModel: SectionViewModel {

}

class NotesItemViewModel: SectionItemViewModel {
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }
    
    public private(set) var editDate: Date = Date()
}
