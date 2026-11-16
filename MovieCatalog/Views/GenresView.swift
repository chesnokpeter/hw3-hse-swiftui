import SwiftData
import SwiftUI

struct GenresView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Genre.name) private var genres: [Genre]
    @State private var genreToDelete: Genre?
    @State private var showingDelete = false
    @State private var showingError = false

    var body: some View {
        NavigationStack {
            List(genres) { genre in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(genre.name)
                            .font(.headline)
                        Text("Фильмов: \(genre.movies.count)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button(role: .destructive) {
                        genreToDelete = genre
                        showingDelete = true
                    } label: {
                        Image(systemName: "trash")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("Удалить жанр \(genre.name)")
                }
            }
            .overlay {
                if genres.isEmpty {
                    ContentUnavailableView(
                        "Жанров пока нет",
                        systemImage: "tag",
                        description: Text("Жанры появляются при добавлении фильмов.")
                    )
                }
            }
            .navigationTitle("Жанры")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Готово") { dismiss() }
                }
            }
            .alert("Удалить жанр?", isPresented: $showingDelete, presenting: genreToDelete) { genre in
                Button("Удалить", role: .destructive) {
                    genreToDelete = nil
                    delete(genre)
                }
                Button("Отмена", role: .cancel) { genreToDelete = nil }
            } message: { genre in
                Text("Жанр «\(genre.name)» будет удалён. Фильмы останутся в каталоге.")
            }
            .alert("Не удалось удалить жанр", isPresented: $showingError) {
                Button("ОК", role: .cancel) {}
            }
        }
    }

    private func delete(_ genre: Genre) {
        modelContext.delete(genre)
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            showingError = true
        }
    }
}
