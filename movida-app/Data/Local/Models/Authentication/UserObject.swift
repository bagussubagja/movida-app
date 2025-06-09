//
//  UserObject.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation
import RealmSwift

class UserObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var uid: String
    @Persisted var email: String?
    
    convenience init(uid: String, email: String?) {
        self.init()
        self.uid = uid
        self.email = email
    }
}
