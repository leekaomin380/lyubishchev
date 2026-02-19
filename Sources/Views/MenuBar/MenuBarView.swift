import SwiftUI

struct MenuBarView: View {
    @Bindable var focusVM: FocusViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if focusVM.isActive, let item = focusVM.currentItem {
                // Active focus session
                HStack {
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    Text("专注中")
                        .font(.caption.bold())
                        .foregroundStyle(.red)
                }

                Text(item.title)
                    .font(.body.bold())
                    .lineLimit(2)

                Text(focusVM.formattedElapsedTime)
                    .font(.system(.title2, design: .monospaced))
                    .monospacedDigit()

                Divider()

                Button("完成任务") {
                    focusVM.completeFocus()
                }

                Button("取消") {
                    focusVM.cancelFocus()
                }
            } else {
                Text("Lyubishchev")
                    .font(.headline)
                Text("暂无进行中的任务")
                    .foregroundStyle(.secondary)
            }

            Divider()

            Button("退出") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(12)
        .frame(width: 220)
    }
}
