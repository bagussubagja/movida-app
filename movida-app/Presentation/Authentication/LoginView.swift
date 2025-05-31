//
//  LoginView.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAnimating = false
    var onLoginSuccess: () -> Void

    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("login_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height)
            }

            Color.black.opacity(0.65)
                .edgesIgnoringSafeArea(.all)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    VStack {
                        Text("Movida App")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)

                        Text("Discover Your Next Favorite Film.")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 80)
                    .padding(.bottom, 40)
                    .shadow(color: .red.opacity(0.5), radius: 20, x: 0, y: 10)

                    VStack(spacing: 16) {
                        CustomTextField(text: $email, placeholder: "Email", icon: "envelope.fill")
                        CustomTextField(text: $password, placeholder: "Password", isSecure: true, icon: "lock.fill")
                    }

                    HStack {
                        Spacer()
                        Button("Forgot Password?") {}
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.7))
                    }

                    Button(action: {
                        onLoginSuccess()
                    }) {
                        Text("Sign In")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(16)
                            .shadow(color: .red.opacity(0.4), radius: 10, y: 5)
                    }
                    .padding(.top, 10)

                    Spacer()

                    // MARK: - Tombol Sign Up
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(.white.opacity(0.7))
                        Button("Sign Up") {}
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    }
                    .font(.subheadline)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 24)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 30)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}
