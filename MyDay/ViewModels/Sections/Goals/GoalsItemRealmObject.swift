//
//  GoalsItemRealmObject.swift
//  MyDay
//
//  Created by Рома Балаян on 15.08.2023.
//

import Foundation
import RealmSwift

class GoalsItemRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var descriptions = List<String>()
    @Persisted var date: Date = Date()
    @Persisted var goalValue: Double = 100
    @Persisted var currentValue: Double = 0
    @Persisted var stepValue: Double = 10
    @Persisted var type: Int = 0
}
