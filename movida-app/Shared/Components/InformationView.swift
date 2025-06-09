//
//  InformationView.swift
//  movida-app
//
//  Created by Bagus Subagja on 09/06/25.
//


import SwiftUI

struct InformationView: View {
    let title: String
    let content: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(content)
                    .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
