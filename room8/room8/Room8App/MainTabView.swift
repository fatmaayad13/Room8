import SwiftUI

struct MainTabView: View {
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @StateObject private var choreViewModel = ChoreScheduleViewModel()

    var body: some View {
        TabView {
            // Expenses Tab
            ExpenseListView()
                .tabItem {
                    Label("Expenses", systemImage: "dollarsign.circle.fill")
                }

            // Chores Tab
            ChoresView(viewModel: choreViewModel, showingAddChore: .constant(false))
                .tabItem {
                    Label("Chores", systemImage: "checkmark.circle.fill")
                }

            // Roommates Tab
            RoommatesView(viewModel: choreViewModel)
                .tabItem {
                    Label("Roommates", systemImage: "person.3.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
