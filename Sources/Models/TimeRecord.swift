import Foundation
import SwiftData

@Model
final class TimeRecord {
    var id: UUID
    var todo: TodoItem?
    var startTime: Date
    var endTime: Date?

    init(todo: TodoItem, startTime: Date = Date()) {
        self.id = UUID()
        self.todo = todo
        self.startTime = startTime
        self.endTime = nil
    }

    var duration: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }

    var formattedDuration: String {
        TodoItem.formatDuration(duration)
    }

    var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: startTime)
    }

    var formattedEndTime: String? {
        guard let endTime else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: endTime)
    }
}
