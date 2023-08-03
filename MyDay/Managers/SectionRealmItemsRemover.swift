//
//  SectionRealmItemsRemover.swift
//  MyDay
//
//  Created by Рома Балаян on 28.07.2023.
//

import Foundation
import RealmSwift

protocol SectionRealmItemsRemoverVisitable where Self: SectionItemViewModel {
    func accept(_ remover: SectionRealmItemsRemover)
}

// Visitor
struct SectionRealmItemsRemover {
    func remove(item: SectionRealmItemsRemoverVisitable) {
        item.accept(self)
    }
    
    func visit(_ item: ScheduleItemViewModel) {
        let config = Realm.Configuration.defaultConfiguration
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.delete(realm.objects(ScheduleItemRealmObject.self).filter("id=%@", item.id))
            }
        } catch let error as NSError {
            print("Error removing item from Realm: \(error.localizedDescription)")
        }
    }
    
    func visit(_ item: NotesItemViewModel) {
        let config = Realm.Configuration.defaultConfiguration
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.delete(item.toRealmObject())
            }
        } catch let error as NSError {
            print("Error removing item from Realm: \(error.localizedDescription)")
        }
    }
}
