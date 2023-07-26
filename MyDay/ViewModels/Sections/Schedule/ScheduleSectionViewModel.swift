//
//  ScheduleSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation
import RealmSwift

final class ScheduleSectionViewModel: SectionViewModel {
    typealias ItemInput = ScheduleItemRealmObject
    
    override public class func type() -> Unforgivable {
        return .schedule
    }
    
    override public func add(_ item: SectionItemViewModel) {
        guard let item = item as? ScheduleItemViewModel else { return }
        
        super.add(item)
        
        let sectionsRealmManager = SectionsRealmManager<ScheduleSectionViewModel, ScheduleItemRealmObject>()
        sectionsRealmManager.update(item: item)
    }
    
    override public func fillWithCommonItems() {
        self.add(ScheduleItemViewModel(title: "Test \(self.date.month)", description: "No Desc", startDate: Date(), endDate: Date(), date: self.date.date))
        self.add(ScheduleItemViewModel(title: "Test \(self.date.day)", description: "No Desc", startDate: Date(), endDate: Date(), date: self.date.date))
    }
    
    func sort() {
        self.items.sort(by: { lhs, rhs in
            if let lhs = lhs as? ScheduleItemViewModel, let rhs = rhs as? ScheduleItemViewModel {
                return lhs.startDate < rhs.startDate
            }
            return false
        })
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    override public class func create(config: DateModel) -> ScheduleSectionViewModel {
        return ScheduleSectionViewModel(date: config)
    }
    
    override public class func createItem(config: Object) -> SectionItemViewModel? {
        if let config = config as? ScheduleItemRealmObject {
            return ScheduleItemViewModel(realmObject: config)
        }
        
        return nil
    }
    
    override public class func updateRealmItem(item: SectionItemViewModel) -> Bool {
        guard let item = item as? ScheduleItemViewModel else { return false }
        let config = Realm.Configuration.defaultConfiguration
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                
                if let existingItem = realm.objects(ScheduleItemRealmObject.self).filter("id == %@", item.id).first {
                    // NOT TESTED
                    existingItem.title = item.title
                    existingItem.desc = item.description
                    existingItem.date = item.date
                    existingItem.startDate = item.startDate
                    existingItem.endDate = item.endDate
                    return true
                } else {
                    // tested
                    realm.add(item.toRealmObject())
                    return false
                }
            }
        } catch let error as NSError {
            print("Error adding sample data to Realm: \(error.localizedDescription)")
        }
        
        return false
    }
    
    override func update() {
        self.inProgressItems = []
        self.nextItems = []
        
        self.sort()
        
        let foundLatestTask = false
        for item in self.items {
            if let item = item as? ScheduleItemViewModel {
                if item.startDate < Date() && item.endDate > Date() {
                    self.inProgressItems.append(item)
                }
                
                if item.startDate > Date() && !foundLatestTask {
                    self.nextItems.append(item)
                }
            }
        }
        
        for handler in onItemsChangedHandlers {
            handler()
        }
    }
    
    public private(set) var inProgressItems: [ScheduleItemViewModel] = []
    public private(set) var nextItems: [ScheduleItemViewModel] = []
}

