//
//  ViewState.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case success
    case failure(Error)

    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.success, .success):
            return true
        case (.failure(let e1), .failure(let e2)):
            return e1.localizedDescription == e2.localizedDescription
        default:
            return false
        }
    }
}
