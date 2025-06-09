//
//  WatchlistMovieObject.swift
//  movida-app
//
//  Created by Bagus Subagja on 08/06/25.
//


import Foundation
import RealmSwift

class WatchlistMovieObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var imageUrl: String
    @Persisted var addedAt: Date
    
    convenience init(id: String, title: String, imageUrl: String, addedAt: Date) {
        self.init()
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.addedAt = addedAt
    }
}