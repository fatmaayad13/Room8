import SwiftUI
import PhotosUI
import PencilKit

// MARK: - Add Text Note
struct AddTextNoteView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var noteText = ""
    @State private var author = ""
    @State private var selectedColor: FridgeStickyColor = .yellow

    var body: some View {
        NavigationView {
            Form {
                Section("Note") {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 100)
                }

                Section("From") {
                    TextField("Your name (optional)", text: $author)
                }

                Section("Color") {
                    HStack(spacing: 16) {
                        ForEach(FridgeStickyColor.allCases, id: \.self) { color in
                            Circle()
                                .fill(color.swiftUIColor)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Circle().stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                )
                                .onTapGesture { selectedColor = color }
                        }
                    }
                }
            }
            .navigationTitle("Add Sticky Note")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addTextNote(
                            text: noteText,
                            author: author.isEmpty ? "Anonymous" : author,
                            color: selectedColor
                        )
                        dismiss()
                    }
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - Add Drawing (Temporarily disabled for demo)
struct AddDrawingView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "pencil.and.scribble")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)
                Text("Drawing feature")
                    .font(.title2)
                Text("Coming soon!")
                    .foregroundColor(.secondary)
            }
            .navigationTitle("Draw Something")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Add Sticker
struct AddStickerView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedEmoji = "😊"

    let emojis = [
        "😊", "❤️", "🎉", "⭐", "🌟", "✨", "🎈", "🎁",
        "🍕", "🍔", "🍎", "🍌", "☕", "🍺", "🎂", "🍰",
        "📝", "📌", "✅", "❗", "💡", "🔥", "👍", "👋",
        "🏠", "🚗", "✈️", "🌈", "☀️", "🌙", "⚡", "💫"
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.system(size: 50))
                            .frame(width: 70, height: 70)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedEmoji == emoji ? Color.blue.opacity(0.2) : Color.clear)
                            )
                            .onTapGesture {
                                selectedEmoji = emoji
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Sticker")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addSticker(emoji: selectedEmoji)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Add Photo
struct AddPhotoView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var author = ""

    var body: some View {
        NavigationView {
            VStack {
                if let imageData = selectedImageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "photo")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No photo selected")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: 300)
                }

                Form {
                    Section {
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Label("Choose Photo", systemImage: "photo.on.rectangle")
                        }
                        .onChange(of: selectedItem) {
                            Task {
                                if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                    }

                    Section("From") {
                        TextField("Your name (optional)", text: $author)
                    }
                }
            }
            .navigationTitle("Add Photo")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let imageData = selectedImageData {
                            viewModel.addPhoto(
                                imageData: imageData,
                                author: author.isEmpty ? "Anonymous" : author
                            )
                            dismiss()
                        }
                    }
                    .disabled(selectedImageData == nil)
                }
            }
        }
    }
}
