import SwiftUI

struct ExpenseListView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel
    @State private var showingAddExpense = false

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Summary Card
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Total Expenses")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black.opacity(0.55))
                            Text(formatCurrency(viewModel.totalExpenses))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Theme.navy)
                        }

                        Spacer()

                        Button {
                            showingAddExpense = true
                        } label: {
                            Circle()
                                .fill(Theme.sage)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.white)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(20)
                    .background(Theme.white)
                    .cornerRadius(Theme.cornerXL)
                    .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
                    .padding(.horizontal, Theme.pad)
                    .padding(.top, 16)

                    // Recent Expenses
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Expenses")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.navy)
                            .padding(.horizontal, Theme.pad)

                        ForEach(viewModel.sortedExpenses) { expense in
                            NavigationLink {
                                ExpenseDetailView(expense: expense, viewModel: viewModel)
                            } label: {
                                ExpenseRowView(expense: expense, viewModel: viewModel)
                            }
                        }
                    }

                    Spacer(minLength: 24)
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            AddExpenseView(viewModel: viewModel)
        }
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    let viewModel: ExpenseViewModel

    var body: some View {
        HStack(spacing: 14) {
            // Category Icon
            Circle()
                .fill(categoryColor(expense.category).opacity(0.2))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: categoryIcon(expense.category))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(categoryColor(expense.category))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                HStack(spacing: 4) {
                    Text(viewModel.userName(for: expense.paidByUserID))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black.opacity(0.5))

                    Text("•")
                        .font(.system(size: 13))
                        .foregroundColor(.black.opacity(0.3))

                    Text(formatDate(expense.date))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black.opacity(0.5))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(expense.amount))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)

                Text(formatCurrency(expense.amountPerPerson) + " each")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.black.opacity(0.45))
            }
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerL)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, Theme.pad)
    }

    private func categoryIcon(_ category: ExpenseCategory) -> String {
        switch category {
        case .groceries: return "cart.fill"
        case .utilities: return "bolt.fill"
        case .rent: return "house.fill"
        case .internet: return "wifi"
        case .cleaning: return "sparkles"
        case .household: return "house"
        case .other: return "ellipsis.circle.fill"
        }
    }

    private func categoryColor(_ category: ExpenseCategory) -> Color {
        switch category {
        case .groceries: return Theme.sage
        case .utilities: return Theme.terracotta
        case .rent: return Theme.navy
        case .internet: return Color.blue
        case .cleaning: return Theme.sage.opacity(0.7)
        case .household: return Theme.terracotta.opacity(0.7)
        case .other: return Color.gray
        }
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ExpenseListView()
}
