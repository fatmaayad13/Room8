import Foundation
import SwiftUI

// MARK: - Fridge Item (can be note, drawing, sticker, or photo)
struct FridgeItem: Identifiable {
    let id: UUID
    var type: FridgeItemType
    var position: CGPoint
    var rotation: Double
    var author: String
    var createdAt: Date

    // Content based on type
    var text: String? // For text notes
    var drawingData: Data? // For drawings
    var emoji: String? // For stickers
    var imageData: Data? // For photos
    var color: FridgeStickyColor

    init(
        id: UUID = UUID(),
        type: FridgeItemType,
        position: CGPoint,
        rotation: Double = Double.random(in: -3...3),
        author: String,
        createdAt: Date = Date(),
        text: String? = nil,
        drawingData: Data? = nil,
        emoji: String? = nil,
        imageData: Data? = nil,
        color: FridgeStickyColor = .yellow
    ) {
        self.id = id
        self.type = type
        self.position = position
        self.rotation = rotation
        self.author = author
        self.createdAt = createdAt
        self.text = text
        self.drawingData = drawingData
        self.emoji = emoji
        self.imageData = imageData
        self.color = color
    }
}

// MARK: - Codable Support
extension FridgeItem: Codable {
    enum CodingKeys: String, CodingKey {
        case id, type, posX, posY, rotation, author, createdAt
        case text, drawingData, emoji, imageData, color
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        type = try container.decode(FridgeItemType.self, forKey: .type)
        let x = try container.decode(CGFloat.self, forKey: .posX)
        let y = try container.decode(CGFloat.self, forKey: .posY)
        position = CGPoint(x: x, y: y)
        rotation = try container.decode(Double.self, forKey: .rotation)
        author = try container.decode(String.self, forKey: .author)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        drawingData = try container.decodeIfPresent(Data.self, forKey: .drawingData)
        emoji = try container.decodeIfPresent(String.self, forKey: .emoji)
        imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        color = try container.decode(FridgeStickyColor.self, forKey: .color)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(position.x, forKey: .posX)
        try container.encode(position.y, forKey: .posY)
        try container.encode(rotation, forKey: .rotation)
        try container.encode(author, forKey: .author)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(drawingData, forKey: .drawingData)
        try container.encodeIfPresent(emoji, forKey: .emoji)
        try container.encodeIfPresent(imageData, forKey: .imageData)
        try container.encode(color, forKey: .color)
    }
}

enum FridgeItemType: String, Codable {
    case textNote
    case drawing
    case sticker
    case photo
}

enum FridgeStickyColor: String, Codable, CaseIterable {
    case yellow, pink, blue, green, peach

    var name: String { rawValue.capitalized }

    var swiftUIColor: Color {
        switch self {
        case .yellow: return Color(red: 1.0, green: 0.98, blue: 0.6)
        case .pink: return Color(red: 1.0, green: 0.8, blue: 0.9)
        case .blue: return Color(red: 0.7, green: 0.9, blue: 1.0)
        case .green: return Color(red: 0.8, green: 1.0, blue: 0.8)
        case .peach: return Color(red: 1.0, green: 0.9, blue: 0.7)
        }
    }
}
