//
//  RealmManager.swift
//  movida-app
//
//  Created by Bagus Subagja on 25/05/25.
//

import RealmSwift

class LocalItem: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
}

class RealmManager {
    static let shared = RealmManager()
    private let realm = try! Realm()

    func create(item: LocalItem) {
        try? realm.write {
            realm.add(item)
        }
    }

    func readAll() -> [LocalItem] {
        return Array(realm.objects(LocalItem.self))
    }

    func update(item: LocalItem) {
        try? realm.write {
            realm.add(item, update: .modified)
        }
    }

    func delete(item: LocalItem) {
        try? realm.write {
            realm.delete(item)
        }
    }
}
