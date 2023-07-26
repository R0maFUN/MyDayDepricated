//
//  NotesItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import UIKit

class NoteDescriptionModel {
    
    public func setText(_ text: String) {
        self.text = text
    }
    
    public private(set) var id: String = UUID().uuidString
    public private(set) var text: String = ""
}

class NotesItemViewModel: SectionItemViewModel {
    
    init() {
        super.init(title: "", date: Date())
    }
    
    init(title: String, description: String = "", editDate: Date, date: Date) {
        super.init(title: title, description: description, date: date)

        self.editDate = editDate
    }
    
    public func addNewDescription() {
        add(description: NoteDescriptionModel())
    }
    
    public func update(_ description: NoteDescriptionModel) {
        if let existingDescription = self.descriptions.first(where: { $0.id == description.id }) {
            existingDescription.setText(description.text) // already set i guess
        } else {
            add(description: description)
        }
        
        self.description = self.descriptions.first?.text ?? ""
        
        self.editDate = Date()
    }
    
    private func add(description: NoteDescriptionModel) {
        if self.descriptions.contains(where: { $0.id == description.id }) {
            return
        }
        
        self.descriptions.append(description)
        
        // update realm
    }
    
    public private(set) var editDate: Date = Date()
    public private(set) var descriptions: [NoteDescriptionModel] = []
    public private(set) var images: [[UIImage]] = [[]]
}
