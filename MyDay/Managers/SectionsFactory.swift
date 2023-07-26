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
//
//struct ScheduleSectionFactory: IGenericFactory {
//    func build(config: DateModel) -> ScheduleSectionViewModel {
//        let section = ScheduleSectionViewModel(date: config)
//        return section
//    }
//}
//
//struct NotesSectionFactory: IGenericFactory {
//    func build(config: DateModel) -> ScheduleSectionViewModel {
//        let section = ScheduleSectionViewModel(date: config)
//        return section
//    }
//}

struct SectionItemsFactory {
    static func create<Input>(_ configuration: Input) -> SectionItemViewModel?
    {
        if let configuration = configuration as? ScheduleItemRealmObject {
            let creator = ScheduleSectionItemsCreator()
            return creator.build(config: configuration)
        }
        
        return nil
    }
}

protocol ISectionItemsCreator {
    associatedtype ItemInput: Object
    func build(config: ItemInput) -> SectionItemViewModel
}

class ScheduleSectionItemsCreator: ISectionItemsCreator {
    func build(config: ScheduleItemRealmObject) -> SectionItemViewModel {
        let item = ScheduleItemViewModel(realmObject: config)
        return item
    }
}

struct NotesSectionItemsCreator: ISectionItemsCreator {
    func build(config: NotesItemRealmObject) -> SectionItemViewModel {
        let item = NotesItemViewModel()
        return item
    }
}

//class BaseSectionItemsFactory<T: Object>: IGenericFactory {
//    typealias Input = T
//
//    func build(config: T) -> SectionItemViewModel {
//        return SectionItemViewModel(title: "empty", date: Date())
//    }
//}

//class ScheduleSectionItemsFactory: BaseSectionItemsFactory<ScheduleItemRealmObject> {
//    override func build(config: ScheduleItemRealmObject) -> ScheduleItemViewModel {
//        let item = ScheduleItemViewModel(realmObject: config)
//        return item
//    }
//}
//
//struct NotesSectionItemsFactory: IGenericFactory {
//    func build(config: NotesItemRealmObject) -> NotesItemViewModel {
//        let item = NotesItemViewModel()
//        return item
//    }
//}

// Current:
// let scheduleSection = SectionsFactory.create(ScheduleSectionFactory(), DateModel())

// Want:
// let section = SectionsFactory<T.self>.create(configuration: dateModel)
