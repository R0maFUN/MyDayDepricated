//
//  SectionsRealmManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import RealmSwift

final class SectionsRealmManager<T: SectionItemViewModel> {
    
}

extension SectionsRealmManager where T == ScheduleItemViewModel {
    func restore() -> [ScheduleItemViewModel] {
        print("SectionsRealmManager, restore [schedule]")
        
        let config = Realm.Configuration.defaultConfiguration
        let realm = try! Realm(configuration: config)
        
        let scheduleRealmItems = realm.objects(ScheduleItemRealmObject.self)
        return scheduleRealmItems.map { return ScheduleItemViewModel(realmObject: $0) }
    }
    
    func update(item: ScheduleItemViewModel) {
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
            print("Error adding sample data to Realm: \(error.localizedDescription)")
        }
    }
}

extension SectionsRealmManager where T == NotesItemViewModel {
    func restore() -> [NotesItemViewModel] {
        print("SectionsRealmManager, restore [notes]")
        return []
    }
    
    func update(item: NotesItemViewModel) {
        
    }
}

extension SectionsRealmManager where T == RemindersItemViewModel {
    func restore() -> [RemindersItemViewModel] {
        print("SectionsRealmManager, restore [reminder]")
        return []
    }
    
    func update(item: RemindersItemViewModel) {
        
    }
}

extension SectionsRealmManager where T == GoalsItemViewModel {
    func restore() -> [GoalsItemViewModel] {
        print("SectionsRealmManager, restore [goals]")
        return []
    }
    
    func update(item: GoalsItemViewModel) {
        
    }
}
