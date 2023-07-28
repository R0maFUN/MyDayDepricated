//
//  SectionsRealmManager.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import RealmSwift

struct SectionsRealmManager<RealmObjectType: Object> {
    static func restore<Output: SectionItemViewModel, Factory: IGenericFactory>(_ object: Factory) -> [Output] where Factory.Input == RealmObjectType,
                                                                                                     Factory.Output == Output {
        let config = Realm.Configuration.defaultConfiguration
        let realm = try! Realm(configuration: config)
        
        let realmItems = realm.objects(RealmObjectType.self)
        return realmItems.compactMap { return object.build(config: $0) }
    }
    
    static func update(item: SectionRealmItemsUpdaterVisitable) {
        let updater = SectionRealmItemsUpdater()
        updater.update(item: item)
    }
}
