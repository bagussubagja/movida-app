//
//  LoginView.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var isAnimating = false
    var onLoginSuccess: () -> Void

    var body: some View {
        ZStack {
            Image("login_background")
                .resizable().scaledToFill().edgesIgnoringSafeArea(.all)
                .overlay(Color.black.opacity(0.65))

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack {
                        Text("Movida App")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                        Text("Discover Your Next Favorite Film.")
                            .font(.headline).fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(.top, 80).padding(.bottom, 40)
                    .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 10)

                    VStack(spacing: 16) {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress).autocapitalization(.none)
                            .padding().background(.white.opacity(0.2)).cornerRadius(16)
                        
                        SecureField("Password", text: $viewModel.password)
                            .padding().background(.white.opacity(0.2)).cornerRadius(16)
                    }
                    .foregroundColor(.white)
                    .tint(.red)
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote).foregroundColor(.red)
                            .padding(.top, 5)
                    }
                    
                    Button(action: {
                        viewModel.authenticate(onSuccess: onLoginSuccess)
                    }) {
                        HStack {
                            if viewModel.isAuthenticating {
                                ProgressView().tint(.white)
                            } else {
                                Text(viewModel.isSigningUp ? "Sign Up" : "Sign In")
                            }
                        }
                        .font(.headline).fontWeight(.bold).foregroundColor(.white)
                        .frame(maxWidth: .infinity).padding().background(Color.red)
                        .cornerRadius(16).shadow(color: .red.opacity(0.4), radius: 10, y: 5)
                    }
                    .disabled(viewModel.isAuthenticating)
                    .padding(.top, 10)

                    Spacer()

                    HStack(spacing: 4) {
                        Text(viewModel.isSigningUp ? "Already have an account?" : "Don't have an account?")
                        Button(viewModel.isSigningUp ? "Sign In" : "Sign Up") {
                            viewModel.isSigningUp.toggle()
                            viewModel.errorMessage = nil
                        }
                        .foregroundColor(.red).fontWeight(.bold)
                    }
                    .font(.subheadline).foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0).offset(y: isAnimating ? 0 : 30)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) { isAnimating = true }
        }
    }
}
