//
//  SectionRealmItemsUpdater.swift
//  MyDay
//
//  Created by Рома Балаян on 28.07.2023.
//

import Foundation
import RealmSwift

protocol SectionRealmItemsUpdaterVisitable where Self: SectionItemViewModel {
    func accept(_ updater: SectionRealmItemsUpdater)
}

// Visitor
struct SectionRealmItemsUpdater {
    func update(item: SectionRealmItemsUpdaterVisitable) {
        item.accept(self)
    }
    
    func visit(_ item: ScheduleItemViewModel) {
        let config = Realm.Configuration.defaultConfiguration
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                if let existingItem = realm.objects(ScheduleItemRealmObject.self).filter("id == %@", item.id).first {
                    existingItem.title = item.title
                    existingItem.desc = item.description
                    existingItem.date = item.date
                    existingItem.startDate = item.startDate
                    existingItem.endDate = item.endDate
                } else {
                    realm.add(item.toRealmObject())
                }
            }
        } catch let error as NSError {
            print("Error updating SceduleItem in Realm: \(error.localizedDescription)")
        }
    }
    
    func visit(_ item: NotesItemViewModel) {
        let config = Realm.Configuration.defaultConfiguration
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                if let existingItem = realm.objects(NotesItemRealmObject.self).filter("id == %@", item.id).first {
                    existingItem.title = item.title
                    existingItem.descriptions.removeAll()
                    existingItem.descriptions.append(objectsIn: item.descriptions.compactMap { return String($0.text) })
                    existingItem.date = item.date
                    existingItem.editDate = item.editDate
                } else {
                    realm.add(item.toRealmObject())
                }
            }
        } catch let error as NSError {
            print("Error updating NotesItem in Realm: \(error.localizedDescription)")
        }
    }
}
