//
//  ScheduleItemRealmObject.swift
//  MyDay
//
//  Created by Рома Балаян on 24.07.2023.
//

import Foundation
import RealmSwift

class ScheduleItemRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var desc: String = ""
    @Persisted var date: Date = Date()
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
}
