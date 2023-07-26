//
//  SectionsRealmManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import RealmSwift

protocol ISectionsRealmManager {
    associatedtype SectionItemType: SectionItemViewModel
    func restore() -> [SectionItemType]
    func update(item: SectionItemType)
}

class SectionsRealmManager<T: SectionViewModel, RealmObjectType: Object>: ISectionsRealmManager {
    func restore() -> [SectionItemViewModel] {
        print("SectionsRealmManager, restore [base]")
        
        let config = Realm.Configuration.defaultConfiguration
        let realm = try! Realm(configuration: config)
        
        let realmItems = realm.objects(RealmObjectType.self)
        return realmItems.compactMap { return T.createItem(config: $0) }
    }
    
    func update(item: SectionItemViewModel) {
        T.updateRealmItem(item: item)
    }
}
