//
//  DashboardView.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//

import SwiftUI


struct DashboardView: View {
    @Binding var navigationPath: NavigationPath
    var onSignOut: () -> Void
    
    @State private var selectedTab: Int = 0
    @Namespace private var animationNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    TrendingView(navigationPath: $navigationPath)
                case 1:
                    HomeView(navigationPath: $navigationPath)
                case 2:
                    ProfileView(navigationPath: $navigationPath, onSignOut: onSignOut)
                default:
                    Text("Not Found!")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab, namespace: animationNamespace)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(Capsule())
                .shadow(color: .primary.opacity(0.15), radius: 10, y: 5)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea(.all, edges: .bottom)
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
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                selectedTab = index
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(selectedTab == index ? .white : .secondary)
                
                if selectedTab == index {
                    Text(title)
                        .font(.subheadline).fontWeight(.bold)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "label_\(index)", in: namespace)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    if selectedTab == index {
                        Capsule()
                            .fill(Color.red)
                            .matchedGeometryEffect(id: "bg", in: namespace)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
