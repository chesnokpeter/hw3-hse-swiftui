import SwiftData
import SwiftUI

#Preview {
    let container = PreviewMovies.container()
    ContentView()
        .modelContainer(container)
}

enum PreviewMovies {
    @MainActor
    static func container() -> ModelContainer {
        let schema = Schema([Movie.self, Genre.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: configuration)
        let context = container.mainContext
        let sciFi = Genre(name: "Фантастика")
        let drama = Genre(name: "Драма")
        let animation = Genre(name: "Анимация")

        context.insert(Movie(title: "Головоломка", year: 2015, genre: animation, isWatched: true, rating: 4))
        context.insert(Movie(title: "Одержимость", year: 2014, genre: drama, isWatched: true, rating: 5))
        context.insert(Movie(title: "Дюна", year: 2021, genre: sciFi))
        context.insert(Movie(title: "Интерстеллар", year: 2014, genre: sciFi, isWatched: true, rating: 5, isFavorite: true))
        return container
    }
}
