//
//  CustomDialogView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct CustomDialogView: View {
    let title: String
    let message: String
    let confirmText: String
    let cancelText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)

            HStack {
                Button(action: onCancel) {
                    Text(cancelText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }

                Button(action: onConfirm) {
                    Text(confirmText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
