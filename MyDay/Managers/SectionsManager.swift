//
//  SectionsManager.swift
//  MyDay
//
//  Created by Рома Балаян on 21.07.2023.
//

import Foundation
import UIKit

func getSectionKeyFrom(date: DateModel) -> Int {
    return 31 * date.monthInt + date.day
//    let components = Calendar.current.dateComponents([.month, .day], from: date)
//    return 31 * components.month! + components.day!
}

protocol ISectionsManager {
    
    // MARK: - Public Methods
    func activate()
    func deactivate()
    
    func setDate(date: DateModel)
    
    func getSection(by date: DateModel) -> SectionViewModel?
    
    func add(section: SectionViewModel)
    
    // MARK: - Properties
    var title: String { get }
    var addActionTitle: String { get }
    var addActionColor: UIColor { get }
    var isActive: PropertyBinding<Bool> { get }
    var sections: PropertyBinding<[Int: SectionViewModel]> { get }
    var currentSection: PropertyBinding<SectionViewModel> { get }
}

class SectionsManager<T: SectionViewModel>: ISectionsManager {
    // MARK: - Init
    init(visibleDates: [DateModel]) {
        self.currentSection = PropertyBinding()
        
        initialize(visibleDates: visibleDates)
        
        self.currentSection.onChanged {
            self.onDataChangedHandlers.forEach { $0() }
        }
    }
    
    // MARK: - Public Methods
    public func activate() {
        self.isActive.value = true
    }
    
    public func deactivate() {
        self.isActive.value = false
    }
    
    public func setDate(date: DateModel) {
        self.currentDate = date
    }
    
    public func getSection(by date: DateModel) -> SectionViewModel? {
        return self.sections.value![getSectionKeyFrom(date: date)]
    }
    
    public func add(section: SectionViewModel) {
        self.sections.value![getSectionKeyFrom(date: section.date)] = section
        
        self.connectToSection(section)
    }
    
    public func onDataChanged(_ handler: @escaping () -> Void) {
        self.onDataChangedHandlers.append(handler)
    }
    
    // MARK: - Internal Methods
    
    // MARK: - Private Methods
    private func initialize(visibleDates: [DateModel]) {
        let restoredSections = restoreSections(T.self)
        
        restoredSections.forEach({ key, value in
            self.add(section: value)
        })
        
        for dateModel in visibleDates {
            if !restoredSections.keys.contains(where: { key in
                return key == dateModel
            }) {
                let section = T.create(config: dateModel)
                section.fillWithCommonItems()
                add(section: section)
            }
        }
    }
    
    private func restoreSections<ST: SectionViewModel>(_ t: ST.Type) -> [DateModel:ST] {
        var restoredItems: [SectionItemViewModelManagedByRealm] = []
        // TODO: Refactor pizdec
        switch T.type() {
        case .base:
            return [:]
        case .schedule:
            restoredItems = SectionsRealmManager<ScheduleItemRealmObject>.restore(ScheduleItemsFactory())
        case .notes:
            restoredItems = SectionsRealmManager<NotesItemRealmObject>.restore(NoteItemsFactory())
        case .reminders:
            //let realmManager = SectionsRealmManager<T, ScheduleItemRealmObject>()
            return [:]
        case .goals:
            restoredItems = SectionsRealmManager<GoalsItemRealmObject>.restore(GoalItemsFactory())
        }
        
        var result: [DateModel:ST] = [:]
        
        for item in restoredItems {
            let dateModel = DateModel(date: item.date)
            
            if !result.keys.contains(where: { $0.day == dateModel.day && $0.monthInt == dateModel.monthInt }) {
                result[dateModel] = ST(date: dateModel)
            }
            
            result[dateModel]?.add(item)
        }
        
        return result
    }
    
    private func connectToSection(_ section: SectionViewModel) {
        section.onItemsChanged {
            self.onDataChangedHandlers.forEach { $0() }
        }
    }
    
    // MARK: - Properties
    public internal(set) var title: String = ""
    public internal(set) var addActionTitle: String = ""
    public internal(set) var addActionColor: UIColor = .link
    public internal(set) var isActive: PropertyBinding<Bool> = PropertyBinding<Bool>(false)
    public internal(set) var sections: PropertyBinding<[Int: SectionViewModel]> = PropertyBinding<[Int: SectionViewModel]>([:])
    public internal(set) var currentSection: PropertyBinding<SectionViewModel>
    
    // MARK: - Private Properties
    private var currentDate: DateModel? {
        didSet {
            self.currentSection.value = self.sections.value![getSectionKeyFrom(date: currentDate!)]
            self.currentSection.value?.update()
        }
    }
    
    private var onDataChangedHandlers: [() -> Void] = []
}
