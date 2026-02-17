import Foundation
import SwiftData

@Model
final class TodoItem {
    var id: UUID
    var title: String
    var category: TaskCategory?
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?

    @Relationship(deleteRule: .cascade, inverse: \TimeRecord.todo)
    var timeRecords: [TimeRecord]

    init(title: String, category: TaskCategory? = nil) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
        self.timeRecords = []
    }

    var totalDuration: TimeInterval {
        timeRecords.reduce(0) { $0 + $1.duration }
    }

    var formattedTotalDuration: String {
        Self.formatDuration(totalDuration)
    }

    static func formatDuration(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
