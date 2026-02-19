import SwiftUI

struct AddTodoView: View {
    @Bindable var todoVM: TodoViewModel

    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .foregroundStyle(.blue)
                .font(.title3)

            TextField("添加任务", text: $todoVM.newTaskTitle)
                .textFieldStyle(.plain)
                .font(.body)
                .onSubmit {
                    todoVM.addTask(title: todoVM.newTaskTitle)
                }
        }
        .padding(12)
        .background(.ultraThinMaterial)
    }
}
