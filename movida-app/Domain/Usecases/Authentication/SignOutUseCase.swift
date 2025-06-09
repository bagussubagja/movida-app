//
//  SignOutUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//


class SignOutUseCase {
    private let repository: AuthRepository
    init(repository: AuthRepository) { self.repository = repository }
    func execute() async throws {
        try await repository.signOut()
    }
}