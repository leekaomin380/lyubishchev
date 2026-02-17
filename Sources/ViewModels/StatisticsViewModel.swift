import Foundation
import SwiftData

enum StatisticsPeriod: String, CaseIterable {
    case day = "Today"
    case week = "This Week"
    case month = "This Month"
}

struct CategoryStat: Identifiable {
    let id = UUID()
    let name: String
    let colorHex: String
    let totalDuration: TimeInterval

    var formattedDuration: String {
        TodoItem.formatDuration(totalDuration)
    }
}

struct DailyStat: Identifiable {
    let id = UUID()
    let date: Date
    let totalDuration: TimeInterval

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }

    var formattedDuration: String {
        TodoItem.formatDuration(totalDuration)
    }
}

@Observable
final class StatisticsViewModel {
    var modelContext: ModelContext?
    var selectedPeriod: StatisticsPeriod = .day
    var categoryStats: [CategoryStat] = []
    var dailyStats: [DailyStat] = []
    var totalDuration: TimeInterval = 0
    var completedCount: Int = 0

    var formattedTotalDuration: String {
        TodoItem.formatDuration(totalDuration)
    }

    func refresh() {
        guard let modelContext else { return }

        let calendar = Calendar.current
        let now = Date()
        let startDate: Date

        switch selectedPeriod {
        case .day:
            startDate = calendar.startOfDay(for: now)
        case .week:
            startDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) ?? now
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
        }

        let descriptor = FetchDescriptor<TimeRecord>(
            predicate: #Predicate { $0.startTime >= startDate }
        )

        guard let records = try? modelContext.fetch(descriptor) else { return }

        totalDuration = records.reduce(0) { $0 + $1.duration }

        let completedDescriptor = FetchDescriptor<TodoItem>(
            predicate: #Predicate { $0.isCompleted && $0.completedAt != nil && $0.completedAt! >= startDate }
        )
        completedCount = (try? modelContext.fetchCount(completedDescriptor)) ?? 0

        // Category stats
        var catMap: [String: (colorHex: String, duration: TimeInterval)] = [:]
        for record in records {
            let catName = record.todo?.category?.name ?? "Uncategorized"
            let catColor = record.todo?.category?.colorHex ?? "#888888"
            let existing = catMap[catName] ?? (colorHex: catColor, duration: 0)
            catMap[catName] = (colorHex: existing.colorHex, duration: existing.duration + record.duration)
        }
        categoryStats = catMap.map { CategoryStat(name: $0.key, colorHex: $0.value.colorHex, totalDuration: $0.value.duration) }
            .sorted { $0.totalDuration > $1.totalDuration }

        // Daily stats
        var dayMap: [Date: TimeInterval] = [:]
        for record in records {
            let day = calendar.startOfDay(for: record.startTime)
            dayMap[day, default: 0] += record.duration
        }
        dailyStats = dayMap.map { DailyStat(date: $0.key, totalDuration: $0.value) }
            .sorted { $0.date < $1.date }
    }
}
