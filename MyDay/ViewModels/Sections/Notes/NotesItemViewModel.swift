//
//  NotesItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import UIKit
import RealmSwift

class NoteDescriptionModel {
    
    init() {
        
    }
    
    init(text: String) {
        self.text = text
    }
    
    public func setText(_ text: String) {
        self.text = text
    }
    
    public private(set) var id: String = UUID().uuidString
    public private(set) var text: String = ""
}

class NotesItemViewModel: SectionItemViewModelManagedByRealm {
    
    // MARK: Init
    init() {
        super.init(title: "", date: Date())
    }
    
    init(title: String, descriptions: [String] = [], editDate: Date, date: Date) {
        super.init(title: title, description: descriptions.first ?? "", date: date)

        self.editDate = editDate
        self.descriptions = descriptions.map { return NoteDescriptionModel(text: $0) }
    }
    
    convenience init(realmObject: NotesItemRealmObject) {
        self.init(title: realmObject.title, descriptions: Array(realmObject.descriptions), editDate: realmObject.editDate, date: realmObject.date)
        
        self.id = realmObject.id
        self.realmObject = realmObject
    }
    
    // MARK: - Public Methods
    public func update(_ description: NoteDescriptionModel) {
        if let existingDescription = self.descriptions.first(where: { $0.id == description.id }) {
            existingDescription.setText(description.text) // already set i guess
        } else {
            add(description: description)
        }
        
        self.description = self.descriptions.first?.text ?? ""
        
        self.editDate = Date()
        
        self.updateRealm()
    }
    
    public func addEmptyDescription() {
        add(description: NoteDescriptionModel())
    }
    
    override func accept(_ updater: SectionRealmItemsUpdater) {
        updater.visit(self)
    }
    
    public func toRealmObject() -> NotesItemRealmObject {
        if realmObject != nil {
            return realmObject!
        }
        
        let object = NotesItemRealmObject()
        object.title = self.title
        object.descriptions.append(objectsIn: self.descriptions.map { return String($0.text) })
        object.date = self.date
        object.id = self.id
        
        self.realmObject = object
        return object
    }
    
    // MARK: - Private Methods
    private func add(description: NoteDescriptionModel) {
        if self.descriptions.contains(where: { $0.id == description.id }) {
            return
        }
        
        self.descriptions.append(description)

        self.updateRealm()
    }
    
    public private(set) var editDate: Date = Date()
    public private(set) var descriptions: [NoteDescriptionModel] = []
    public private(set) var images: [[UIImage]] = [[]]
    
    private var realmObject: NotesItemRealmObject?
}
