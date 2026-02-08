//
//  MainTabView.swift
//  Room8App_UI
//
//  Created by ktnguyenx on 2/8/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // HOME
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            // CALENDAR
            NavigationStack {
                CalendarRootView()
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

            // MONEY
            NavigationStack {
                MoneyRootView()
            }
            .tabItem {
                Label("Money", systemImage: "dollarsign")
            }

            // MORE
            NavigationStack {
                MoreView()
            }
            .tabItem {
                Label("More", systemImage: "ellipsis")
            }
        }
    }
}
