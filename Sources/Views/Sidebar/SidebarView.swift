import SwiftUI
import SwiftData

struct SidebarView: View {
    @Query(sort: \TaskCategory.name) private var categories: [TaskCategory]
    @Bindable var todoVM: TodoViewModel

    @State private var isAddingCategory = false
    @State private var newCategoryName = ""
    @State private var newCategoryColor = "#007AFF"

    var body: some View {
        List(selection: Binding(
            get: { todoVM.selectedCategory?.id },
            set: { id in
                todoVM.selectedCategory = categories.first { $0.id == id }
            }
        )) {
            Section("列表") {
                Label("全部任务", systemImage: "tray.fill")
                    .tag(nil as UUID?)
                    .onTapGesture {
                        todoVM.selectedCategory = nil
                    }

                ForEach(categories) { category in
                    Label {
                        Text(category.name)
                    } icon: {
                        Circle()
                            .fill(category.color)
                            .frame(width: 10, height: 10)
                    }
                    .tag(category.id as UUID?)
                    .contextMenu {
                        Button("删除", role: .destructive) {
                            todoVM.deleteCategory(category)
                        }
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                if isAddingCategory {
                    HStack {
                        TextField("分类名称", text: $newCategoryName)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                todoVM.addCategory(name: newCategoryName, colorHex: newCategoryColor)
                                newCategoryName = ""
                                isAddingCategory = false
                            }
                        Button("添加") {
                            todoVM.addCategory(name: newCategoryName, colorHex: newCategoryColor)
                            newCategoryName = ""
                            isAddingCategory = false
                        }
                        .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                    .padding(.horizontal)
                }

                Button {
                    isAddingCategory.toggle()
                } label: {
                    Label(isAddingCategory ? "取消" : "新建列表", systemImage: isAddingCategory ? "xmark" : "plus")
                }
                .buttonStyle(.plain)
                .padding(.bottom, 8)
            }
        }
    }
}
