import SwiftUI
import SwiftData

struct MovieFields {
    var title = ""
    var year = String(Calendar.current.component(.year, from: .now))
    var genre = ""

    var cleanTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var cleanGenre: String {
        genre.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var validYear: Int? {
        guard let number = Int(year), (1888...2100).contains(number) else { return nil }
        return number
    }

    var canSave: Bool {
        !cleanTitle.isEmpty && !cleanGenre.isEmpty && validYear != nil
    }

    func findGenre(in genres: [Genre], context: ModelContext) -> Genre {
        if let existing = genres.first(where: { $0.name.localizedCaseInsensitiveCompare(cleanGenre) == .orderedSame }) {
            return existing
        }

        let newGenre = Genre(name: cleanGenre)
        context.insert(newGenre)
        return newGenre
    }
}

struct MovieForm: View {
    @Binding var fields: MovieFields
    @Binding var isWatched: Bool
    @Binding var isFavorite: Bool
    @Binding var rating: Int

    var body: some View {
        Form {
            Section("О фильме") {
                TextField("Название", text: $fields.title)
                    .textInputAutocapitalization(.sentences)

                TextField("Жанр", text: $fields.genre)
                    .textInputAutocapitalization(.sentences)

                LabeledContent("Год выпуска") {
                    TextField("1888–2100", text: $fields.year)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .accessibilityLabel("Год выпуска")
                }

                if !fields.year.isEmpty && fields.validYear == nil {
                    Text("Введите год от 1888 до 2100")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Просмотр") {
                Toggle(isOn: $isWatched) {
                    Label("Просмотрено", systemImage: "checkmark.circle")
                }

                Picker(selection: $rating) {
                    Text("Без оценки").tag(0)
                    ForEach(1...5, id: \.self) { value in
                        Text("\(value) из 5").tag(value)
                    }
                } label: {
                    Label("Оценка", systemImage: "star")
                }

                Toggle(isOn: $isFavorite) {
                    Label("В избранном", systemImage: "heart")
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
