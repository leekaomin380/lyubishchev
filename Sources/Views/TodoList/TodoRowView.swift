import SwiftUI

struct TodoRowView: View {
    let item: TodoItem
    var onStart: (() -> Void)?
    var onToggleComplete: (() -> Void)?
    var onDelete: (() -> Void)?

    var body: some View {
        HStack(spacing: 12) {
            Button {
                onToggleComplete?()
            } label: {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .strikethrough(item.isCompleted)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)

                HStack(spacing: 8) {
                    if let category = item.category {
                        Text(category.name)
                            .font(.caption)
                            .foregroundStyle(category.color)
                    }
                    if item.isCompleted, let completedAt = item.completedAt {
                        Text("Done \(completedAt, style: .relative) ago")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if item.totalDuration > 0 {
                        Text(item.formattedTotalDuration)
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()

            if !item.isCompleted {
                Button {
                    onStart?()
                } label: {
                    Image(systemName: "play.fill")
                        .font(.body)
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                .help("Start focus on this task")
            }
        }
        .padding(.vertical, 4)
        .contextMenu {
            if item.isCompleted {
                Button("Mark as Incomplete") {
                    onToggleComplete?()
                }
            }
            Button("Delete", role: .destructive) {
                onDelete?()
            }
        }
    }
}
