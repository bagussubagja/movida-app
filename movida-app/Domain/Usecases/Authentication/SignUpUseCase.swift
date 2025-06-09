//
//  SignUpUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation

class SignUpUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(withEmail email: String, password: String) async throws -> User {
        try await repository.signUp(withEmail: email, password: password)
    }
}
