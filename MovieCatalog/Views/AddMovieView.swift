import SwiftUI
import SwiftData

struct AddMovieView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var genres: [Genre]
    @State private var fields = MovieFields()
    @State private var isWatched = false
    @State private var isFavorite = false
    @State private var rating = 0
    @State private var showingSaveError = false

    var body: some View {
        NavigationStack {
            MovieForm(fields: $fields, isWatched: $isWatched, isFavorite: $isFavorite, rating: $rating)
                .navigationTitle("Новый фильм")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("Сохранить", action: saveMovie)
                            .disabled(!fields.canSave)
                    }
                }
                .alert("Не удалось сохранить фильм", isPresented: $showingSaveError) {
                    Button("OK", role: .cancel) { }
                }
        }
    }

    private func saveMovie() {
        guard fields.canSave, let year = fields.validYear else { return }
        let genre = fields.findGenre(in: genres, context: modelContext)
        let movie = Movie(
            title: fields.cleanTitle,
            year: year,
            genre: genre,
            isWatched: isWatched,
            rating: rating,
            isFavorite: isFavorite
        )
        modelContext.insert(movie)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.rollback()
            showingSaveError = true
        }
    }
}
