//
//  CustomBottomSheetView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

struct CustomBottomSheetView<Content: View>: View {
    let title: String
    let onDismiss: () -> Void
    let onSave: () -> Void
    let saveText: String
    let cancelText: String
    let content: () -> Content

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text(title)
                .font(.headline)
                .padding(.top, 8)

            content()
                .padding(.horizontal)

            HStack {
                Button(cancelText) {
                    onDismiss()
                }
                .foregroundColor(.red)

                Spacer()

                Button(saveText) {
                    onSave()
                }
                .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .padding(.top, 10)
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
}
