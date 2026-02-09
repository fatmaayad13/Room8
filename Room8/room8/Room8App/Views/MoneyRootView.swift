//
//  MoneyRootView.swift
//  Room8App
//

import SwiftUI

struct MoneyRootView: View {
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @State private var selectedSegment = 0

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Money")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(Theme.navy)
                    Spacer()
                }
                .padding(.horizontal, Theme.pad)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Segmented Control
                Picker("View", selection: $selectedSegment) {
                    Text("Expenses").tag(0)
                    Text("Shopping").tag(1)
                    Text("Balance").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, Theme.pad)
                .padding(.bottom, 12)

                // Content based on selection
                TabView(selection: $selectedSegment) {
                    // Expenses Tab
                    ExpenseListView()
                        .environmentObject(expenseViewModel)
                        .tag(0)

                    // Shopping Tab (placeholder for now)
                    ShoppingListView()
                        .tag(1)

                    // Balance Tab
                    BalanceView()
                        .environmentObject(expenseViewModel)
                        .tag(2)
                }
                #if os(iOS)
.tabViewStyle(.page(indexDisplayMode: .never))
#endif
            }
        }
        #if os(iOS)
.navigationBarHidden(true)
#endif
    }
}

// MARK: - Shopping List View (Placeholder)
struct ShoppingListView: View {
    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Shopping List")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Theme.navy)
                        .padding(.top, 16)

                    VStack(spacing: 12) {
                        ShoppingItemRow(name: "Milk", addedBy: "Fatma", checked: false)
                        ShoppingItemRow(name: "Eggs", addedBy: "You", checked: true)
                        ShoppingItemRow(name: "Bread", addedBy: "Lorraine", checked: false)
                        ShoppingItemRow(name: "Coffee", addedBy: "Efrata", checked: false)
                    }
                    .padding(.horizontal, Theme.pad)
                }
            }
        }
    }
}

struct ShoppingItemRow: View {
    let name: String
    let addedBy: String
    @State var checked: Bool

    var body: some View {
        HStack(spacing: 14) {
            Button {
                checked.toggle()
            } label: {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(checked ? Theme.sage : .gray.opacity(0.3))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(checked ? .black.opacity(0.4) : .black)
                    .strikethrough(checked)
                Text("Added by \(addedBy)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black.opacity(0.45))
            }

            Spacer()
        }
        .padding(14)
        .background(Theme.white)
        .cornerRadius(Theme.cornerM)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
