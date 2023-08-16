//
//  SectionsFactory.swift
//  MyDay
//
//  Created by Рома Балаян on 26.07.2023.
//

import Foundation
import RealmSwift

protocol IGenericFactory {
    associatedtype Input
    associatedtype Output
    func build(config: Input) -> Output
}

//struct SectionsFactory {
//    static func create<Output: SectionsViewModel, Input, Factory: IGenericFactory>(_ object: Factory,_ configuration: Input) -> Output where Factory.Output == Output,
//                        Factory.Input == Input {
//        object.build(config: configuration)
//    }
//}

struct ScheduleItemsFactory: IGenericFactory {
    func build(config: ScheduleItemRealmObject) -> ScheduleItemViewModel {
        let item = ScheduleItemViewModel(realmObject: config)
        return item
    }
}

struct NoteItemsFactory: IGenericFactory {
    func build(config: NotesItemRealmObject) -> NotesItemViewModel {
        let item = NotesItemViewModel(realmObject: config)
        return item
    }
}

struct GoalItemsFactory: IGenericFactory {
    func build(config: GoalsItemRealmObject) -> GoalsItemViewModel {
        let item = GoalsItemViewModel(realmObject: config)
        return item
    }
}
