//
//  AuthRepositoryImpl.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let authService: AuthService
        
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signIn(withEmail email: String, password: String) async throws -> User {
        try await authService.signIn(withEmail: email, password: password)
    }
    
    func signUp(withEmail email: String, password: String) async throws -> User {
        try await authService.signUp(withEmail: email, password: password)
    }
    
    func signOut() async throws { try await authService.signOut() }
    
    func getCurrentUser() -> User? { return authService.getCurrentUser() }
}
