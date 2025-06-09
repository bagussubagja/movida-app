//
//  LoginViewModel.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//


import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticating = false
    @Published var errorMessage: String?
    
    @Published var isSigningUp = false
    
    private let signInUseCase: SignInUseCase
    private let signUpUseCase: SignUpUseCase
    
    init(
        signInUseCase: SignInUseCase = ServiceLocator.shared.signInUseCase,
        signUpUseCase: SignUpUseCase = ServiceLocator.shared.signUpUseCase
    ) {
        self.signInUseCase = signInUseCase
        self.signUpUseCase = signUpUseCase
    }
    
    func authenticate(onSuccess: @escaping () -> Void) {
        isAuthenticating = true
        errorMessage = nil
        
        Task {
            do {
                if isSigningUp {
                    _ = try await signUpUseCase.execute(withEmail: email, password: password)
                } else {
                    _ = try await signInUseCase.execute(withEmail: email, password: password)
                }
                onSuccess()
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isAuthenticating = false
        }
    }
}
