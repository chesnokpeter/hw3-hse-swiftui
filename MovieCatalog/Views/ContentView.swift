import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var status = MovieFilter.all
    @State private var sort = MovieSort.date
    @State private var favoritesOnly = false
    @State private var isSelecting = false
    @State private var addingMovie = false
    @State private var showingGenres = false

    var body: some View {
        NavigationStack {
            MovieList(
                searchText: searchText,
                status: $status,
                sort: sort,
                favoritesOnly: $favoritesOnly,
                isSelecting: $isSelecting
            )
            .navigationTitle("Фильмы")
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Название или жанр"
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if !isSelecting {
                        Menu("Действия", systemImage: "ellipsis.circle") {
                            Menu("Сортировка", systemImage: "arrow.up.arrow.down") {
                                Picker("Сортировка", selection: $sort) {
                                    ForEach(MovieSort.allCases, id: \.self) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                            }
                            Button("Жанры", systemImage: "tag") { showingGenres = true }
                            Button("Выбрать фильмы", systemImage: "checkmark.circle") {
                                isSelecting = true
                            }
                        }
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    if isSelecting {
                        Button("Готово") { isSelecting = false }
                    } else {
                        Button("Добавить фильм", systemImage: "plus") {
                            addingMovie = true
                        }
                    }
                }

            }
            .sheet(isPresented: $addingMovie) { AddMovieView() }
            .sheet(isPresented: $showingGenres) { GenresView() }
        }
    }
}
