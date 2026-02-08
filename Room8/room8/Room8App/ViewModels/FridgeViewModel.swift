import Foundation
import SwiftUI
import PencilKit

@MainActor
class FridgeViewModel: ObservableObject {
    @Published var items: [FridgeItem] = []
    @Published var showingAddNote = false
    @Published var showingAddDrawing = false
    @Published var showingAddSticker = false
    @Published var showingAddPhoto = false

    private let storageKey = "fridgeItems"

    init() {
        load()
    }

    // MARK: - Add Items

    func addTextNote(text: String, author: String, color: FridgeStickyColor) {
        let position = randomPosition()
        let item = FridgeItem(
            type: .textNote,
            position: position,
            author: author,
            text: text,
            color: color
        )
        items.append(item)
        save()
    }

    func addDrawing(drawing: PKDrawing, author: String) {
        let position = randomPosition()
        let item = FridgeItem(
            type: .drawing,
            position: position,
            author: author,
            drawingData: drawing.dataRepresentation()
        )
        items.append(item)
        save()
    }

    func addSticker(emoji: String) {
        let position = randomPosition()
        let item = FridgeItem(
            type: .sticker,
            position: position,
            author: "Sticker",
            emoji: emoji
        )
        items.append(item)
        save()
    }

    func addPhoto(imageData: Data, author: String) {
        let position = randomPosition()
        let item = FridgeItem(
            type: .photo,
            position: position,
            author: author,
            imageData: imageData
        )
        items.append(item)
        save()
    }

    // MARK: - Update & Delete

    func updatePosition(_ item: FridgeItem, to position: CGPoint) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].position = position
            save()
        }
    }

    func deleteItem(_ item: FridgeItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    // MARK: - Storage

    private func save() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([FridgeItem].self, from: data) {
            items = decoded
        }
    }

    private func randomPosition() -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 100...300),
            y: CGFloat.random(in: 150...600)
        )
    }
}

