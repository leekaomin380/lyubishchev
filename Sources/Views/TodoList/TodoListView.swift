import SwiftUI
import SwiftData

struct TodoListView: View {
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var allItems: [TodoItem]
    @Bindable var todoVM: TodoViewModel
    @Bindable var focusVM: FocusViewModel

    private var filteredItems: [TodoItem] {
        if let category = todoVM.selectedCategory {
            return allItems.filter { $0.category?.id == category.id }
        }
        return allItems
    }

    private var pendingItems: [TodoItem] {
        filteredItems.filter { !$0.isCompleted }
    }

    private var completedItems: [TodoItem] {
        filteredItems.filter { $0.isCompleted }
    }

    var body: some View {
        VStack(spacing: 0) {
            if pendingItems.isEmpty && completedItems.isEmpty {
                ContentUnavailableView {
                    Label("暂无任务", systemImage: "checklist")
                } description: {
                    Text("在下方添加一个任务开始使用。")
                }
            } else {
                List {
                    if !pendingItems.isEmpty {
                        Section("待办 — \(pendingItems.count)") {
                            ForEach(pendingItems) { item in
                                TodoRowView(
                                    item: item,
                                    onStart: { focusVM.startFocus(on: item) },
                                    onToggleComplete: { todoVM.completeTask(item) },
                                    onDelete: { todoVM.deleteTask(item) }
                                )
                            }
                        }
                    }

                    if !completedItems.isEmpty {
                        Section("已完成 — \(completedItems.count)") {
                            ForEach(completedItems) { item in
                                TodoRowView(
                                    item: item,
                                    onToggleComplete: { todoVM.uncompleteTask(item) },
                                    onDelete: { todoVM.deleteTask(item) }
                                )
                            }
                        }
                    }
                }
            }

            AddTodoView(todoVM: todoVM)
        }
        .navigationTitle(todoVM.selectedCategory?.name ?? "全部任务")
    }
}
