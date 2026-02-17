import Foundation
import SwiftData
import SwiftUI

@Observable
final class TodoViewModel {
    var modelContext: ModelContext?
    var selectedCategory: TaskCategory?
    var newTaskTitle: String = ""

    func addTask(title: String, category: TaskCategory? = nil) {
        guard let modelContext, !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = TodoItem(title: title.trimmingCharacters(in: .whitespaces), category: category ?? selectedCategory)
        modelContext.insert(item)
        try? modelContext.save()
        newTaskTitle = ""
    }

    func completeTask(_ item: TodoItem) {
        item.isCompleted = true
        item.completedAt = Date()
        try? modelContext?.save()
    }

    func deleteTask(_ item: TodoItem) {
        modelContext?.delete(item)
        try? modelContext?.save()
    }

    func uncompleteTask(_ item: TodoItem) {
        item.isCompleted = false
        item.completedAt = nil
        try? modelContext?.save()
    }

    func addCategory(name: String, colorHex: String = "#007AFF") {
        guard let modelContext, !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let category = TaskCategory(name: name.trimmingCharacters(in: .whitespaces), colorHex: colorHex)
        modelContext.insert(category)
        try? modelContext.save()
    }

    func deleteCategory(_ category: TaskCategory) {
        if selectedCategory?.id == category.id {
            selectedCategory = nil
        }
        modelContext?.delete(category)
        try? modelContext?.save()
    }
}
