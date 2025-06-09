//
//  AuthRepository.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation

protocol AuthRepository {
    func signIn(withEmail email: String, password: String) async throws -> User
    func signUp(withEmail email: String, password: String) async throws -> User
    func signOut() async throws
    func getCurrentUser() -> User?
}
