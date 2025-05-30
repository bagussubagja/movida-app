//
//  ViewState.swift
//  movida-app
//
//  Created by Bagus Subagja on 30/05/25.
//


import Combine

enum ViewState {
    case idle, loading, success, failure(Error)
}
