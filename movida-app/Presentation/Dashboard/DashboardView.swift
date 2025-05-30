//
//  DashboardView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI

struct DashboardView: View {
    @Binding var navigationPath: NavigationPath
    @State private var selectedTab: Int = 0
    @Namespace private var animationNamespace

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case 0:
                        TrendingView()
                    case 1:
                        HomeView()
                    case 2:
                        ProfileView()
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CustomTabBar(selectedTab: $selectedTab, namespace: animationNamespace)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    var namespace: Namespace.ID

    var body: some View {
        HStack(spacing: 16) {
            TabButton(title: "Trending", index: 0, icon: "flame.fill", selectedTab: $selectedTab, namespace: namespace)
            TabButton(title: "Home", index: 1, icon: "house.fill", selectedTab: $selectedTab, namespace: namespace)
            TabButton(title: "Profile", index: 2, icon: "person.crop.circle.fill", selectedTab: $selectedTab, namespace: namespace)
        }
    }
}


struct TabButton: View {
    let title: String
    let index: Int
    let icon: String
    @Binding var selectedTab: Int
    var namespace: Namespace.ID

    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedTab = index
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(selectedTab == index ? .white : .gray)

                if selectedTab == index {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .matchedGeometryEffect(id: "label_\(index)", in: namespace)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    if selectedTab == index {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue)
                            .matchedGeometryEffect(id: "bg", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

