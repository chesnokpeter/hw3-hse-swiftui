import SwiftData
import SwiftUI

struct MovieList: View {
    @Environment(\.modelContext) private var context
    @Query private var allMovies: [Movie]
    @Query private var movies: [Movie]
    @Binding private var status: MovieFilter
    @Binding private var favoritesOnly: Bool
    @Binding private var isSelecting: Bool
    @State private var selection: Set<PersistentIdentifier> = []
    @State private var errorMessage: String?

    private let searchText: String

    init(
        searchText: String,
        status: Binding<MovieFilter>,
        sort: MovieSort,
        favoritesOnly: Binding<Bool>,
        isSelecting: Binding<Bool>
    ) {
        self.searchText = searchText
        _favoritesOnly = favoritesOnly
        _status = status
        _isSelecting = isSelecting
        _movies = Query(
            filter: MovieFilter.predicate(
                searchText: searchText,
                status: status.wrappedValue,
                favoritesOnly: favoritesOnly.wrappedValue
            ),
            sort: sort.descriptors
        )
    }

    var body: some View {
        List(selection: isSelecting ? $selection : nil) {
            MovieStats(movies: allMovies)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

            Picker("Статус", selection: $status) {
                ForEach(MovieFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)

            Section {
                if movies.isEmpty {
                    emptyState
                } else {
                    ForEach(movies) { movie in
                        if isSelecting {
                            MovieRow(movie: movie)
                                .tag(movie.persistentModelID)
                        } else {
                            NavigationLink {
                                MovieDetailView(movie: movie)
                            } label: {
                                MovieRow(movie: movie)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    movie.isWatched.toggle()
                                    saveChanges()
                                } label: {
                                    Label(
                                        movie.isWatched ? "Не просмотрено" : "Просмотрено",
                                        systemImage: movie.isWatched ? "eye.slash" : "checkmark"
                                    )
                                }
                                .tint(.accentColor)
                            }
                            .swipeActions(edge: .trailing) {
                                Button("Удалить", systemImage: "trash", role: .destructive) {
                                    context.delete(movie)
                                    saveChanges()
                                }
                                Button {
                                    movie.isFavorite.toggle()
                                    saveChanges()
                                } label: {
                                    Label(
                                        movie.isFavorite ? "Из избранного" : "В избранное",
                                        systemImage: movie.isFavorite ? "heart.slash" : "heart"
                                    )
                                }
                                .tint(.pink)
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text(favoritesOnly ? "Избранное" : "Каталог")
                    Spacer()
                    Button {
                        favoritesOnly.toggle()
                    } label: {
                        Image(systemName: favoritesOnly ? "heart.fill" : "heart")
                            .font(.body.weight(.medium))
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.borderless)
                    .foregroundStyle(favoritesOnly ? Color.pink : Color.accentColor)
                    .accessibilityLabel(favoritesOnly ? "Показать все фильмы" : "Показать избранное")
                }
            }
        }
        .listStyle(.insetGrouped)
        .environment(\.editMode, .constant(isSelecting ? .active : .inactive))
        .onChange(of: isSelecting) {
            selection.removeAll()
        }
        .onChange(of: movies.map(\.persistentModelID)) { _, ids in
            selection.formIntersection(ids)
        }
        .toolbar {
            if isSelecting {
                ToolbarItem(placement: .bottomBar) {
                    Button("Отметить просмотренными (\(selection.count))", systemImage: "checkmark.circle") {
                        markSelectedAsWatched()
                    }
                    .disabled(selection.isEmpty)
                }
            }
        }
        .alert("Изменения не сохранены", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("ОК", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    private var emptyState: some View {
        let isFiltered = favoritesOnly || status != .all || !searchText.isEmpty
        return ContentUnavailableView(
            isFiltered ? "Фильмы не найдены" : "Список пока пуст",
            systemImage: isFiltered ? "magnifyingglass" : "film",
            description: Text(isFiltered ? "Попробуйте изменить поиск или фильтр." : "Нажмите +, чтобы добавить фильм.")
        )
    }

    private func markSelectedAsWatched() {
        for movie in movies where selection.contains(movie.persistentModelID) {
            movie.isWatched = true
        }
        if saveChanges() {
            isSelecting = false
        }
    }

    @discardableResult
    private func saveChanges() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            errorMessage = error.localizedDescription
            return false
        }
    }
}
