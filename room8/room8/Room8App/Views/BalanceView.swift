import SwiftUI

struct BalanceView: View {
    @EnvironmentObject var viewModel: ExpenseViewModel

    var balances: [UserBalance] {
        viewModel.calculateBalances()
    }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Who Owes Who Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Who Owes Who")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.navy)
                            .padding(.horizontal, Theme.pad)
                            .padding(.top, 16)

                        ForEach(balances) { balance in
                            BalanceRowView(balance: balance, isCurrentUser: balance.user.id == viewModel.currentUser.id)
                                .padding(.horizontal, Theme.pad)
                        }
                    }

                    // Summary Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Summary by Category")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Theme.navy)
                            .padding(.horizontal, Theme.pad)
                            .padding(.top, 12)

                        VStack(spacing: 10) {
                            ForEach(viewModel.expensesByCategory, id: \.category) { item in
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(categoryColor(item.category).opacity(0.2))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: categoryIcon(item.category))
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(categoryColor(item.category))
                                        )

                                    Text(item.category.rawValue)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.black)

                                    Spacer()

                                    Text(formatCurrency(item.total))
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                                .padding(14)
                                .background(Theme.white)
                                .cornerRadius(Theme.cornerM)
                            }

                            // Total
                            HStack {
                                Text("Total")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)

                                Spacer()

                                Text(formatCurrency(viewModel.totalExpenses))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Theme.navy)
                            }
                            .padding(16)
                            .background(Theme.sand.opacity(0.5))
                            .cornerRadius(Theme.cornerM)
                        }
                        .padding(.horizontal, Theme.pad)
                    }

                    Spacer(minLength: 24)
                }
            }
        }
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
}

struct BalanceRowView: View {
    let balance: UserBalance
    let isCurrentUser: Bool

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(balanceColor.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: balance.netBalance >= 0 ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(balanceColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(isCurrentUser ? "You" : balance.user.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Text(balance.owesOrOwed)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.5))
            }

            Spacer()

            Text(formatCurrency(abs(balance.netBalance)))
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(balanceColor)
        }
        .padding(16)
        .background(Theme.white)
        .cornerRadius(Theme.cornerL)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
    }

    private var balanceColor: Color {
        if balance.netBalance > 0 {
            return Theme.sage
        } else if balance.netBalance < 0 {
            return Theme.terracotta
        } else {
            return .gray
        }
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: amount as NSDecimalNumber) ?? "$0.00"
    }
}

#Preview {
    NavigationView {
        BalanceView()
            .environmentObject(ExpenseViewModel())
    }
}
