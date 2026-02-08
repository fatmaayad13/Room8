import SwiftUI
import PhotosUI
import PencilKit

struct EnhancedFridgeView: View {
    @StateObject private var viewModel = FridgeViewModel()
    @State private var showingAddMenu = false

    var body: some View {
        NavigationView {
            ZStack {
                // Fridge background
                Color(red: 0.95, green: 0.95, blue: 0.97)
                    .ignoresSafeArea()

                if viewModel.items.isEmpty {
                    // Empty state
                    VStack(spacing: 16) {
                        Image(systemName: "refrigerator")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.3))
                        Text("Your fridge is empty!")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Tap + to add notes, drawings, stickers, or photos")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }

                // All fridge items (draggable)
                ForEach(viewModel.items) { item in
                    DraggableFridgeItem(
                        item: item,
                        onMove: { newPosition in
                            viewModel.updatePosition(item, to: newPosition)
                        },
                        onDelete: {
                            viewModel.deleteItem(item)
                        }
                    )
                }
            }
            .navigationTitle("Fridge Board")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            viewModel.showingAddNote = true
                        } label: {
                            Label("Sticky Note", systemImage: "note.text")
                        }

                        Button {
                            viewModel.showingAddDrawing = true
                        } label: {
                            Label("Drawing", systemImage: "scribble")
                        }

                        Button {
                            viewModel.showingAddSticker = true
                        } label: {
                            Label("Sticker", systemImage: "face.smiling")
                        }

                        Button {
                            viewModel.showingAddPhoto = true
                        } label: {
                            Label("Photo", systemImage: "photo")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddNote) {
                AddTextNoteView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingAddDrawing) {
                AddDrawingView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingAddSticker) {
                AddStickerView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showingAddPhoto) {
                AddPhotoView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Draggable Fridge Item
struct DraggableFridgeItem: View {
    let item: FridgeItem
    let onMove: (CGPoint) -> Void
    let onDelete: () -> Void

    @State private var position: CGPoint
    @State private var showingDelete = false

    init(item: FridgeItem, onMove: @escaping (CGPoint) -> Void, onDelete: @escaping () -> Void) {
        self.item = item
        self.onMove = onMove
        self.onDelete = onDelete
        _position = State(initialValue: item.position)
    }

    var body: some View {
        Group {
            switch item.type {
            case .textNote:
                TextNoteCard(item: item, onDelete: { showingDelete = true })
            case .drawing:
                DrawingNoteCard(item: item, onDelete: { showingDelete = true })
            case .sticker:
                StickerCard(item: item, onDelete: { showingDelete = true })
            case .photo:
                PhotoCard(item: item, onDelete: { showingDelete = true })
            }
        }
        .position(position)
        .rotationEffect(.degrees(item.rotation))
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.location
                }
                .onEnded { value in
                    position = value.location
                    onMove(value.location)
                }
        )
        .confirmationDialog("Delete this item?", isPresented: $showingDelete) {
            Button("Delete", role: .destructive, action: onDelete)
        }
    }
}

// MARK: - Text Note Card
struct TextNoteCard: View {
    let item: FridgeItem
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            Text(item.text ?? "")
                .font(.body)
                .foregroundColor(.black.opacity(0.8))

            Spacer()

            HStack {
                Text(item.author)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.5))
                Spacer()
            }
        }
        .padding()
        .frame(width: 150, height: 150)
        .background(item.color.swiftUIColor)
        .cornerRadius(4)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Drawing Note Card
struct DrawingNoteCard: View {
    let item: FridgeItem
    let onDelete: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            if let drawingData = item.drawingData,
               let drawing = try? PKDrawing(data: drawingData) {
                Image(uiImage: drawing.image(from: CGRect(x: 0, y: 0, width: 150, height: 150), scale: 1.0))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            HStack {
                Text(item.author)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.5))
                Spacer()
            }
        }
        .padding()
        .frame(width: 170, height: 170)
        .background(Color.white)
        .cornerRadius(4)
        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Sticker Card
struct StickerCard: View {
    let item: FridgeItem
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(item.emoji ?? "❓")
                .font(.system(size: 60))

            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .background(Circle().fill(Color.white))
            }
            .offset(x: 10, y: -10)
        }
        .frame(width: 80, height: 80)
    }
}

// MARK: - Photo Card
struct PhotoCard: View {
    let item: FridgeItem
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            if let imageData = item.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipped()
            }

            HStack {
                Text(item.author)
                    .font(.caption2)
                    .foregroundColor(.black.opacity(0.6))
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            .padding(8)
            .background(Color.white)
        }
        .frame(width: 140, height: 160)
        .background(Color.white)
        .cornerRadius(4)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
    }
}

#Preview {
    EnhancedFridgeView()
}
