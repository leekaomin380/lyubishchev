import Foundation
import SwiftData
import Combine

@Observable
final class FocusViewModel {
    var modelContext: ModelContext?
    var currentItem: TodoItem?
    var currentRecord: TimeRecord?
    var elapsedTime: TimeInterval = 0
    var isActive: Bool = false

    private var timer: Timer?

    var formattedElapsedTime: String {
        TodoItem.formatDuration(elapsedTime)
    }

    var startTimeString: String {
        guard let record = currentRecord else { return "--:--:--" }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: record.startTime)
    }

    var menuBarTitle: String {
        guard let item = currentItem, isActive else { return "Lyubishchev" }
        let compact = TodoItem.formatDuration(elapsedTime)
        let titlePrefix = item.title.prefix(15)
        return "\(titlePrefix) \(compact)"
    }

    func startFocus(on item: TodoItem) {
        guard let modelContext else { return }
        currentItem = item
        isActive = true

        let record = TimeRecord(todo: item, startTime: Date())
        modelContext.insert(record)
        item.timeRecords.append(record)
        currentRecord = record
        elapsedTime = 0

        try? modelContext.save()
        startTimer()
    }

    func completeFocus() {
        guard let modelContext else { return }
        stopTimer()

        currentRecord?.endTime = Date()
        if let item = currentItem {
            item.isCompleted = true
            item.completedAt = Date()
        }

        try? modelContext.save()

        currentItem = nil
        currentRecord = nil
        elapsedTime = 0
        isActive = false
    }

    func cancelFocus() {
        guard let modelContext else { return }
        stopTimer()

        currentRecord?.endTime = Date()
        try? modelContext.save()

        currentItem = nil
        currentRecord = nil
        elapsedTime = 0
        isActive = false
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self, let record = self.currentRecord else { return }
            self.elapsedTime = Date().timeIntervalSince(record.startTime)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
