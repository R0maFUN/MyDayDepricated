//
//  SectionItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation

class SectionItemViewModel {
    
    init(title: String, description: String = "", date: Date) {
        self.title = title
        self.description = description
        self.date = date
    }
    
    public func setTitle(title: String) {
        self.title = title
        
        self.onTitleChangedHandlers.forEach { $0() }
    }
    
    public func onTitleChanged(_ handler: @escaping () -> Void) {
        onTitleChangedHandlers.append(handler)
    }
    
    public func setDescription(description: String) {
        self.description = description
    }
    
    public func setDate(date: Date) {
        self.date = date
    }
    
    public private(set) var title: String = ""
    public internal(set) var description: String = ""
    public private(set) var date: Date
    
    private var onTitleChangedHandlers: [() -> Void] = []
}

class SectionItemViewModelManagedByRealm: SectionItemViewModel, SectionRealmItemsUpdaterVisitable, SectionRealmItemsRemoverVisitable {
    func accept(_ remover: SectionRealmItemsRemover) {
        fatalError("Must be overriden")
    }
    
    func accept(_ updater: SectionRealmItemsUpdater) {
        fatalError("Must be overriden")
    }
    
    public func updateRealm() {
        // if has realmObject
        let updater = SectionRealmItemsUpdater()
        updater.update(item: self)
    }
    
    public func remove() {
        let remover = SectionRealmItemsRemover()
        remover.remove(item: self)
    }
    
    override public func setTitle(title: String) {
        super.setTitle(title: title)
        
        updateRealm()
    }
    
    override public func setDescription(description: String) {
        super.setDescription(description: description)
        
        updateRealm()
    }
    
    override public func setDate(date: Date) {
        super.setDate(date: date)
        
        updateRealm()
    }
    
    public internal(set) var id: String = UUID().uuidString
    
}
