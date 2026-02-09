import SwiftUI
import PencilKit

// MARK: - Whiteboard View
struct WhiteboardView: View {
    @StateObject private var viewModel = WhiteboardViewModel()
    @State private var noteText = ""
    @State private var noteAuthor = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Whiteboard")) {
                    VStack(spacing: 16) {
                        Image(systemName: "pencil.and.scribble")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("Drawing canvas")
                            .font(.headline)
                        Text("Coming soon!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 320)
                    .frame(maxWidth: .infinity)
                    .listRowInsets(EdgeInsets())
                }

                Section(header: Text("Add Note")) {
                    VStack(alignment: .leading, spacing: 8) {
                        TextField("Write a note or a birthday message...", text: $noteText, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                        TextField("From (optional)", text: $noteAuthor)

                        HStack {
                            Spacer()
                            Button("Post") {
                                viewModel.addNote(text: noteText, author: noteAuthor)
                                noteText = ""
                                noteAuthor = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section(header: Text("Notes")) {
                    if viewModel.notes.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Image(systemName: "note.text")
                                    .font(.system(size: 32))
                                    .foregroundColor(.secondary)
                                Text("No notes yet")
                                    .font(.headline)
                                Text("Add a note to get started")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 12)
                    } else {
                        ForEach(viewModel.notes) { note in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(note.text)
                                    .font(.body)
                                HStack {
                                    Text(note.author)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(note.createdAt, style: .date)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                        .onDelete(perform: viewModel.deleteNotes)
                    }
                }
            }
            .navigationTitle("Whiteboard")
        }
    }
}


#Preview {
    WhiteboardView()
}
