//
//  NotesItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import UIKit
import RealmSwift

class NotesItemViewModel: SectionItemViewModelManagedByRealm {
    
    // MARK: Init
    init() {
        super.init(title: "", date: Date())
    }
    
    init(title: String, descriptions: [String] = [], editDate: Date, date: Date, type: NotesSection.type_ = .Common) {
        super.init(title: title, description: descriptions.first ?? "", date: date)

        self.editDate = editDate
        self.descriptions = descriptions.map { return DescriptionModel(text: $0) }
        self.type = type
    }
    
    convenience init(realmObject: NotesItemRealmObject) {
        self.init(title: realmObject.title, descriptions: Array(realmObject.descriptions), editDate: realmObject.editDate, date: realmObject.date, type: NotesSection.type_(rawValue: realmObject.type)!)
        
        self.id = realmObject.id
        self.realmObject = realmObject
    }
    
    // MARK: - Public Methods
    public func update(_ description: DescriptionModel) {
        
        if !self.descriptions.contains(where: { $0.id == description.id }) {
            add(description: description)
        }
        
//        if let existingDescription = self.descriptions.first(where: { $0.id == description.id }) {
//            //existingDescription.setText(description.text) // already set i guess
//        } else {
//            add(description: description)
//        }
        
        self.description = self.descriptions.first?.text ?? ""
        
        self.editDate = Date()
        
        self.updateRealm()
    }
    
    public func addEmptyDescription() {
        add(description: DescriptionModel())
    }
    
    override func accept(_ updater: SectionRealmItemsUpdater) {
        updater.visit(self)
    }
    
    override func accept(_ remover: SectionRealmItemsRemover) {
        remover.visit(self)
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
        object.type = self.type.rawValue
        
        
        self.realmObject = object
        return object
    }
    
    // MARK: - Private Methods
    private func add(description: DescriptionModel) {
        if self.descriptions.contains(where: { $0.id == description.id }) {
            return
        }
        
        self.descriptions.append(description)

        self.updateRealm()
    }
    
    public private(set) var editDate: Date = Date()
    public private(set) var descriptions: [DescriptionModel] = []
    public private(set) var images: [[UIImage]] = [[]]
    public private(set) var type: NotesSection.type_ = .Common
    
    private var realmObject: NotesItemRealmObject?
}
