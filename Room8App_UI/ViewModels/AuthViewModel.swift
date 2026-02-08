//
//  AuthViewModel.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false

    func login(email: String, password: String) async {
        // MOCK: accept a test credential
        if email.lowercased() == "test@room8.com" && password == "password" {
            isLoggedIn = true
        } else {
            // or accept anything:
            // isLoggedIn = true
        }
    }

    func logout() {
        isLoggedIn = false
    }
}
