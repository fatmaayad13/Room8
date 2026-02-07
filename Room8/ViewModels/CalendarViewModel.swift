import Foundation

// MARK: - Calendar View Model
@MainActor
class CalendarViewModel: ObservableObject {
    @Published var items: [CalendarItem] = []

    private let storageService = StorageService.shared

    init() {
        load()
    }

    var sortedItems: [CalendarItem] {
        items.sorted { $0.date < $1.date }
    }

    func addItem(
        title: String,
        type: CalendarItem.ItemType,
        date: Date,
        notes: String?,
        amount: Double?
    ) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let trimmedNotes = notes?.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedAmount = (type == .expense) ? amount : nil

        let item = CalendarItem(
            title: trimmedTitle,
            type: type,
            date: date,
            notes: trimmedNotes?.isEmpty == true ? nil : trimmedNotes,
            amount: cleanedAmount
        )

        items.append(item)
        save()
    }

    func deleteItems(at offsets: IndexSet) {
        let sorted = sortedItems
        for index in offsets {
            let id = sorted[index].id
            items.removeAll { $0.id == id }
        }
        save()
    }

    private func load() {
        items = storageService.loadCalendarItems()
    }

    private func save() {
        storageService.saveCalendarItems(items)
    }
}
