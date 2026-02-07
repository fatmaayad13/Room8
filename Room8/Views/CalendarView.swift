import SwiftUI

// MARK: - Calendar View
struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showingAddItem = false

    var body: some View {
        NavigationView {
            List {
                if viewModel.sortedItems.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 36))
                            .foregroundColor(.secondary)
                        Text("No calendar items yet")
                            .font(.headline)
                        Text("Add chores, events, or expense due dates")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                } else {
                    ForEach(viewModel.sortedItems) { item in
                        CalendarItemRow(item: item)
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }
            }
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddCalendarItemView(viewModel: viewModel, isPresented: $showingAddItem)
            }
        }
    }
}

// MARK: - Calendar Item Row
private struct CalendarItemRow: View {
    let item: CalendarItem

    private var typeColor: Color {
        switch item.type {
        case .chore:
            return .blue
        case .event:
            return .purple
        case .expense:
            return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.title)
                    .font(.headline)
                Spacer()
                Text(item.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 8) {
                Text(item.type.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(typeColor.opacity(0.2))
                    .foregroundColor(typeColor)
                    .cornerRadius(4)

                if item.type == .expense, let amount = item.amount {
                    Text(String(format: "$%.2f", amount))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if let notes = item.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Add Calendar Item View
private struct AddCalendarItemView: View {
    @ObservedObject var viewModel: CalendarViewModel
    @Binding var isPresented: Bool

    @State private var title = ""
    @State private var type: CalendarItem.ItemType = .chore
    @State private var date = Date()
    @State private var notes = ""
    @State private var amountText = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    Picker("Type", selection: $type) {
                        ForEach(CalendarItem.ItemType.allCases, id: \.self) { itemType in
                            Text(itemType.rawValue).tag(itemType)
                        }
                    }
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                if type == .expense {
                    Section(header: Text("Amount")) {
                        TextField("Amount", text: $amountText)
                            .keyboardType(.decimalPad)
                    }
                }

                Section(header: Text("Notes")) {
                    TextField("Optional notes", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addItem(
                            title: title,
                            type: type,
                            date: date,
                            notes: notes,
                            amount: parsedAmount()
                        )
                        isPresented = false
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private func parsedAmount() -> Double? {
        let trimmed = amountText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let value = Double(trimmed) else { return nil }
        return value
    }
}

#Preview {
    CalendarView()
}
