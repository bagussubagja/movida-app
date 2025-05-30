//
//  CustomSnackbarView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct CustomSnackbarView: View {
    let message: String
    var backgroundColor: Color = Color.black.opacity(0.8)
    var textColor: Color = .white

    var body: some View {
        VStack {
            Spacer()
            Text(message)
                .foregroundColor(textColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeInOut, value: message)
        .transition(.move(edge: .bottom))
        .zIndex(1000)
    }
}

