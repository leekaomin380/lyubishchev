import Foundation
import SwiftData

struct ReportEntry: Identifiable {
    let id = UUID()
    let taskTitle: String
    let categoryName: String
    let startTime: Date
    let endTime: Date?
    let duration: TimeInterval

    var formattedTimeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let start = formatter.string(from: startTime)
        let end = endTime.map { formatter.string(from: $0) } ?? "进行中"
        return "\(start) - \(end)"
    }

    var formattedDuration: String {
        TodoItem.formatDuration(duration)
    }
}

@Observable
final class ReportViewModel {
    var modelContext: ModelContext?
    var selectedDate: Date = Date()
    var entries: [ReportEntry] = []
    var totalDuration: TimeInterval = 0

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: selectedDate)
    }

    var formattedTotalDuration: String {
        TodoItem.formatDuration(totalDuration)
    }

    var reportText: String {
        var lines: [String] = []
        lines.append("日报 — \(formattedDate)")
        lines.append(String(repeating: "=", count: 40))
        lines.append("")

        for entry in entries {
            lines.append("\(entry.formattedTimeRange)  \(entry.taskTitle) [\(entry.categoryName)]  (\(entry.formattedDuration))")
        }

        lines.append("")
        lines.append(String(repeating: "-", count: 40))
        lines.append("合计: \(formattedTotalDuration)")
        return lines.joined(separator: "\n")
    }

    func refresh() {
        guard let modelContext else { return }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let descriptor = FetchDescriptor<TimeRecord>(
            predicate: #Predicate { $0.startTime >= startOfDay && $0.startTime < endOfDay },
            sortBy: [SortDescriptor(\.startTime)]
        )

        guard let records = try? modelContext.fetch(descriptor) else { return }

        entries = records.map { record in
            ReportEntry(
                taskTitle: record.todo?.title ?? "未知任务",
                categoryName: record.todo?.category?.name ?? "未分类",
                startTime: record.startTime,
                endTime: record.endTime,
                duration: record.duration
            )
        }

        totalDuration = entries.reduce(0) { $0 + $1.duration }
    }

    func previousDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
        refresh()
    }

    func nextDay() {
        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
        refresh()
    }
}
