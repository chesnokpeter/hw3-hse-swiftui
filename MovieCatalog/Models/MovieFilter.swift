import Foundation

enum MovieFilter: String, CaseIterable {
    case all = "Все"
    case unwatched = "Не просмотрено"
    case watched = "Просмотрено"

    static func predicate(
        searchText: String,
        status: MovieFilter,
        favoritesOnly: Bool
    ) -> Predicate<Movie> {
        let search = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let searchIsEmpty = search.isEmpty
        let filtersWatched = status != .all
        let isWatched = status == .watched

        return #Predicate<Movie> { movie in
            (!filtersWatched || movie.isWatched == isWatched)
                && (!favoritesOnly || movie.isFavorite)
                && (searchIsEmpty || movie.title.localizedStandardContains(search)
                    || (movie.genre?.name.localizedStandardContains(search) ?? false))
        }
    }
}

enum MovieSort: String, CaseIterable {
    case date = "Дата добавления"
    case title = "Название"
    case year = "Год"
    case rating = "Оценка"

    var descriptors: [SortDescriptor<Movie>] {
        switch self {
        case .date:
            [SortDescriptor(\.createdAt, order: .reverse)]
        case .title:
            [SortDescriptor(\.title), SortDescriptor(\.createdAt, order: .reverse)]
        case .year:
            [SortDescriptor(\.year, order: .reverse), SortDescriptor(\.createdAt, order: .reverse)]
        case .rating:
            [SortDescriptor(\.rating, order: .reverse), SortDescriptor(\.createdAt, order: .reverse)]
        }
    }
}
