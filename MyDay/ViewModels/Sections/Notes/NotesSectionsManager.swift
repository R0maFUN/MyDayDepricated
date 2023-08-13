//
//  NotesSectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

final class NotesSectionsManager: SectionsManager<NotesSectionViewModel> {
    
    override init(visibleDates: [DateModel]) {
        super.init(visibleDates: visibleDates)
        
        self.title = "Notes"
        self.addActionTitle = "Note"
        self.addActionColor = NotesColors.primary
    }
}
