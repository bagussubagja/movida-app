//
//  AuthServiceImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation
import FirebaseAuth
import RealmSwift

class AuthServiceImpl: AuthService {

    func signIn(withEmail email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        let user = User(uid: authResult.user.uid, email: authResult.user.email)
        return user
    }

    func signUp(withEmail email: String, password: String) async throws -> User {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        let user = User(uid: authResult.user.uid, email: authResult.user.email)
        return user
    }

    func signOut() async throws {
        try Auth.auth().signOut()
    }
    
    func getCurrentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(uid: firebaseUser.uid, email: firebaseUser.email)
    }
}
