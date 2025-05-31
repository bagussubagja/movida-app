//
//  ShimmerModifier.swift
//  movida-app
//
//  Created by Bagus Subagja on 31/05/25.
//


import SwiftUI

struct ShimmerModifier: ViewModifier {
    let isActive: Bool
    let duration: Double

    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .rotationEffect(.degrees(30))
                            .offset(x: -geometry.size.width * 2 + phase, y: 0)
                            .frame(width: geometry.size.width * 3)
                    }
                )
                .mask(content)
                .onAppear {
                    withAnimation(Animation.linear(duration: duration).repeatForever(autoreverses: false)) {
                        phase = UIScreen.main.bounds.width * 3
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func shimmering(active: Bool = true, duration: Double = 1.0) -> some View {
        self.modifier(ShimmerModifier(isActive: active, duration: duration))
    }
}
