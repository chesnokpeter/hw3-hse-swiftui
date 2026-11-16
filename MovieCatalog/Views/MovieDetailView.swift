import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var genres: [Genre]
    @Bindable var movie: Movie
    @State private var fields: MovieFields
    @State private var showingSaveError = false

    init(movie: Movie) {
        self.movie = movie
        _fields = State(initialValue: MovieFields(title: movie.title, year: String(movie.year), genre: movie.genre?.name ?? ""))
    }

    var body: some View {
        MovieForm(fields: $fields, isWatched: $movie.isWatched, isFavorite: $movie.isFavorite, rating: $movie.rating)
            .navigationTitle("Редактирование")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить", action: saveMovie)
                        .disabled(!fields.canSave)
                }
            }
            .alert("Не удалось сохранить фильм", isPresented: $showingSaveError) {
                Button("OK", role: .cancel) { }
            }
    }

    private func saveMovie() {
        guard fields.canSave, let year = fields.validYear else { return }
        movie.title = fields.cleanTitle
        movie.year = year
        movie.genre = fields.findGenre(in: genres, context: modelContext)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.rollback()
            showingSaveError = true
        }
    }
}
