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

// MARK: - Add Drawing
struct AddDrawingView: View {
    @ObservedObject var viewModel: FridgeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var canvas = PKCanvasView()
    @State private var author = ""

    var body: some View {
        NavigationView {
            VStack {
                DrawingCanvasView(canvas: $canvas)
                    .frame(height: 400)

                Form {
                    Section("From") {
                        TextField("Your name (optional)", text: $author)
                    }
                }
            }
            .navigationTitle("Draw Something")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let drawing = canvas.drawing
                        viewModel.addDrawing(
                            drawing: drawing,
                            author: author.isEmpty ? "Anonymous" : author
                        )
                        dismiss()
                    }
                    .disabled(canvas.drawing.strokes.isEmpty)
                }
            }
        }
    }
}

struct DrawingCanvasView: UIViewRepresentable {
    @Binding var canvas: PKCanvasView

    func makeUIView(context: Context) -> PKCanvasView {
        canvas.drawingPolicy = .anyInput
        canvas.tool = PKInkingTool(.pen, color: .black, width: 3)

        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()

        return canvas
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
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
