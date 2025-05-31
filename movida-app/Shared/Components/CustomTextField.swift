//
//  CustomTextField.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var isSecure: Bool = false
    var icon: String = "magnifyingglass"

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.8))

            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColors.darkBlue)
        .cornerRadius(28)
    }
}
