//
//  GoalsItemViewModel.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation
import UIKit
import RealmSwift

class GoalsItemViewModel: SectionItemViewModelManagedByRealm {
    
    public enum GoalType: Int {
        case Counter = 0
        case Timer = 1
        case Checker = 2
    }
    
    // MARK: Init
    init() {
        super.init(title: "", date: Date())
    }
    
    init(descriptions: (String, String) = ("", ""), goalValue: CGFloat = 0.0, currentValue: CGFloat = 0.0, stepValue: CGFloat = 0.0, date: Date, type: GoalType = .Counter) {
        super.init(title: "", description: "", date: date)

        self.goalValue = goalValue
        self.currentValue = currentValue
        self.stepValue = stepValue
        self.descriptions = descriptions
        self.type = type
    }
    
    convenience init(realmObject: GoalsItemRealmObject) {
        self.init(descriptions: (realmObject.descriptions.first ?? "", realmObject.descriptions.last ?? ""), goalValue: realmObject.goalValue, currentValue: realmObject.currentValue, stepValue: realmObject.stepValue, date: realmObject.date, type: GoalType(rawValue: realmObject.type)!)
        
        self.id = realmObject.id
        self.realmObject = realmObject
    }
    
    // MARK: - Public Methods
    public func updateWithRealm(descriptions: (String, String)? = nil, currentValue: CGFloat? = nil, stepValue: CGFloat? = nil, goalValue: CGFloat? = nil) {
        
        self.descriptions = descriptions ?? self.descriptions
        self.currentValue = currentValue ?? self.currentValue
        self.stepValue = stepValue ?? self.stepValue
        self.goalValue = goalValue ?? self.goalValue
        
        self.updateRealm()
    }
    
    public func update(descriptions: (String, String)? = nil, currentValue: CGFloat? = nil, stepValue: CGFloat? = nil, goalValue: CGFloat? = nil) {
        
        self.descriptions = descriptions ?? self.descriptions
        self.currentValue = currentValue ?? self.currentValue
        self.stepValue = stepValue ?? self.stepValue
        self.goalValue = goalValue ?? self.goalValue
    }
    
    public func setDescriptionFirst(description: String) {
        self.descriptions.0 = description
        
        self.update()
        
        self.descriptionFirstChanged()
    }
    
    public func onDescriptionFirstChanged(_ handler: @escaping () -> Void) {
        self.onDescriptionFirstChangedHandlers.append(handler)
    }
    
    public func descriptionFirstChanged() {
        self.onDescriptionFirstChangedHandlers.forEach { $0() }
    }
    
    public func setDescriptionSecond(description: String) {
        self.descriptions.1 = description
        
        self.update()
        
        self.descriptionSecondChanged()
    }
    
    public func onDescriptionSecondChanged(_ handler: @escaping () -> Void) {
        self.onDescriptionSecondChangedHandlers.append(handler)
    }
    
    public func descriptionSecondChanged() {
        self.onDescriptionSecondChangedHandlers.forEach { $0() }
    }
    
    public func setGoalValue(value: String) {
        self.goalValue = CGFloat(Double(value) ?? 100.0)
        
        self.update()
        
        self.goalValueChanged()
    }
    
    public func onGoalValueChanged(_ handler: @escaping () -> Void) {
        self.onGoalValueChangedHandlers.append(handler)
    }
    
    public func goalValueChanged() {
        self.onGoalValueChangedHandlers.forEach { $0() }
    }
    
    public func setStepValue(value: String) {
        self.stepValue = CGFloat(Double(value) ?? 10.0)
        
        self.update()
        
        self.stepValueChanged()
    }
    
    public func onStepValueChanged(_ handler: @escaping () -> Void) {
        self.onStepValueChangedHandlers.append(handler)
    }
    
    public func stepValueChanged() {
        self.onStepValueChangedHandlers.forEach { $0() }
    }
    
    public func onCurrentValueChanged(_ handler: @escaping () -> Void) {
        self.onCurrentValueChangedHandlers.append(handler)
    }
    
    public func increase() {
        self.currentValue += stepValue
        
        self.update(currentValue: self.currentValue)
        
        self.onCurrentValueChangedHandlers.forEach { $0() }
    }
    
    public func decrease() {
        if self.currentValue - stepValue < 0 {
            return
        }
        
        self.currentValue -= stepValue
        
        self.update(currentValue: self.currentValue)
        
        self.onCurrentValueChangedHandlers.forEach { $0() }
    }
    
    public func isFinished() -> Bool {
        return currentValue >= goalValue
    }
    
    override func accept(_ updater: SectionRealmItemsUpdater) {
        updater.visit(self)
    }
    
    override func accept(_ remover: SectionRealmItemsRemover) {
        remover.visit(self)
    }
    
    public func toRealmObject() -> GoalsItemRealmObject {
        if realmObject != nil {
            return realmObject!
        }
        
        let object = GoalsItemRealmObject()
        object.title = self.title
        object.descriptions.append(objectsIn: [self.descriptions.0, self.descriptions.1])
        object.goalValue = self.goalValue
        object.currentValue = self.currentValue
        object.stepValue = self.stepValue
        object.date = self.date
        object.id = self.id
        object.type = self.type.rawValue
        
        
        self.realmObject = object
        return object
    }
    
    // MARK: - Private Methods
    
    public private(set) var descriptions: (String, String) = ("", "")
    public private(set) var goalValue: CGFloat = 100
    public private(set) var currentValue: CGFloat = 0
    public private(set) var stepValue: CGFloat = 10
    public private(set) var type: GoalType = .Counter
    
    private var realmObject: GoalsItemRealmObject?
    
    private var onCurrentValueChangedHandlers: [() -> Void] = []
    private var onDescriptionFirstChangedHandlers: [() -> Void] = []
    private var onDescriptionSecondChangedHandlers: [() -> Void] = []
    private var onGoalValueChangedHandlers: [() -> Void] = []
    private var onStepValueChangedHandlers: [() -> Void] = []
}
