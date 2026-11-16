import SwiftUI

struct MovieStats: View {
    let movies: [Movie]

    private var averageRating: String {
        let ratedMovies = movies.filter { $0.rating > 0 }
        guard !ratedMovies.isEmpty else { return "–" }
        let sum = ratedMovies.reduce(0) { $0 + $1.rating }
        return (Double(sum) / Double(ratedMovies.count)).formatted(.number.precision(.fractionLength(1)))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Весь каталог", systemImage: "film.stack")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color(red: 0.65, green: 0.91, blue: 0.79))

            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 12) {
                    total
                    watched
                    rating
                }
                VStack(alignment: .leading, spacing: 10) {
                    total
                    watched
                    rating
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(.linearGradient(
                    colors: [Color(red: 0.06, green: 0.25, blue: 0.20), Color(red: 0.09, green: 0.16, blue: 0.16)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
        }
    }

    private var total: some View {
        stat("Фильмов", value: movies.count.formatted())
    }

    private var watched: some View {
        stat("Просмотрено", value: movies.filter(\.isWatched).count.formatted())
    }

    private var rating: some View {
        stat("Средняя оценка", value: averageRating)
    }

    private func stat(_ title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .semibold))
                .monospacedDigit()
                .foregroundStyle(.white)
            Text(title)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.78))
        }
        .fixedSize(horizontal: true, vertical: false)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
