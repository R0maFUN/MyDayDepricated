//
//  NotesSectionViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 16.07.2023.
//

import Foundation
import RealmSwift

class NotesSectionViewModel: SectionViewModel {
    override public class func type() -> Unforgivable {
        return .notes
    }
    
    override public func fillWithCommonItems() {
        self.add(NotesItemViewModel(title: "Test note \(self.date.month)", descriptions: ["No Desc"], editDate: Date(), date: self.date.date))
        self.add(NotesItemViewModel(title: "Test note \(self.date.day)", descriptions: ["No Desc"], editDate: Date(), date: self.date.date))
    }
    
//    func sort() {
//        self.items.sort(by: { lhs, rhs in
//            if let lhs = lhs as? ScheduleItemViewModel, let rhs = rhs as? ScheduleItemViewModel {
//                return lhs.startDate < rhs.startDate
//            }
//            return false
//        })
//
//        for handler in onItemsChangedHandlers {
//            handler()
//        }
//    }
    
    override public class func create(config: DateModel) -> NotesSectionViewModel {
        return NotesSectionViewModel(date: config)
    }
}
