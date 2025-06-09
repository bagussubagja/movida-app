//
//  SignInUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//


import Foundation

class SignInUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(withEmail email: String, password: String) async throws -> User {
        try await repository.signIn(withEmail: email, password: password)
    }
}
