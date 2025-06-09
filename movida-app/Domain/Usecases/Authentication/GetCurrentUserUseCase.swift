//
//  GetCurrentUserUseCase.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//

import Foundation

class GetCurrentUserUseCase {
    private let repository: AuthRepository
    init(repository: AuthRepository) { self.repository = repository }
    func execute() -> User? {
        return repository.getCurrentUser()
    }
}
