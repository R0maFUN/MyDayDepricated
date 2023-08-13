//
//  NotesItemRealmObject.swift
//  MyDay
//
//  Created by Рома Балаян on 26.07.2023.
//

import Foundation

import RealmSwift

class NotesItemRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var descriptions = List<String>() // NoteDescriptionModel
    @Persisted var date: Date = Date()
    @Persisted var editDate: Date = Date()
    @Persisted var type: Int = 0

    // public private(set) var images: [[UIImage]] = [[]]
}
