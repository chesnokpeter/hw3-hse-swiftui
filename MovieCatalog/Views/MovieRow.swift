import SwiftUI

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: movie.isWatched ? "checkmark" : "film")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(movie.isWatched ? Color.accentColor : Color.secondary)
                .frame(width: 42, height: 42)
                .background(
                    (movie.isWatched ? Color.accentColor : Color.secondary).opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 12)
                )
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                Text("\(movie.genreName) · \(movie.year.formatted(.number.grouping(.never)))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 6)

            if movie.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundStyle(.pink)
                    .accessibilityLabel("В избранном")
            }
            if movie.rating > 0 {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text("\(movie.rating)").monospacedDigit()
                }
                .font(.subheadline.weight(.medium))
                .accessibilityLabel("Оценка \(movie.rating) из 5")
            }
        }
        .padding(.vertical, 5)
        .accessibilityElement(children: .combine)
        .accessibilityValue(movie.isWatched ? "Просмотрено" : "Не просмотрено")
    }
}
