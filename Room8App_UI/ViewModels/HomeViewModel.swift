//
//  HomeViewModel.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var greetingName: String = "Lorraine"

    @Published var billLine: String = "Wi-Fi bill ($50) due in 3 days!"
    @Published var notes: [String] = [
        "Happy\nBirthday\nFatma! <3",
        "Rmb to\ntake out\nthe trash!!",
        "Are we\ngoing to\nthat party…"
    ]

    @Published var choresDue: Int = 2
    @Published var moneyOwed: Int = 45
    @Published var toBuyCount: Int = 3
    @Published var updatesCount: Int = 5

    @Published var activity: [String] = [
        "Fatma completed “Take out trash”",
        "Kashaf added expense “Popcorn”",
        "Efrata added “Paper towels” to list"
    ]
}
