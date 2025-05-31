//
//  TabCategory.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import SwiftUI

enum TabCategory: String, CaseIterable {
    case movies = "Movies"
    case tvSeries = "Tv Series"
    case documentary = "Documentary"
    case sports = "Sports"
}

struct CustomTabBarView: View {
    @Binding var selected: TabCategory

    var body: some View {
        HStack(spacing: 20) {
            ForEach(TabCategory.allCases, id: \.self) { tab in
                VStack(spacing: 4) {
                    Text(tab.rawValue)
                        .foregroundColor(selected == tab ? .orange : .white)
                        .fontWeight(selected == tab ? .bold : .regular)
                    if selected == tab {
                        Capsule()
                            .fill(Color.orange)
                            .frame(height: 2)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                            .frame(height: 2)
                    }
                }
                .onTapGesture {
                    selected = tab
                }
            }
        }
    }
}
