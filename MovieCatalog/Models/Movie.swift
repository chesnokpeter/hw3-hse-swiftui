import Foundation
import SwiftData

@Model
final class Movie {
    var title: String
    var year: Int
    var genre: Genre?
    var isWatched: Bool
    var rating: Int
    var createdAt: Date
    var isFavorite: Bool

    var genreName: String {
        genre?.name ?? "Без жанра"
    }

    init(
        title: String,
        year: Int,
        genre: Genre? = nil,
        isWatched: Bool = false,
        rating: Int = 0,
        createdAt: Date = .now,
        isFavorite: Bool = false
    ) {
        self.title = title
        self.year = year
        self.genre = genre
        self.isWatched = isWatched
        self.rating = rating
        self.createdAt = createdAt
        self.isFavorite = isFavorite
    }
}
