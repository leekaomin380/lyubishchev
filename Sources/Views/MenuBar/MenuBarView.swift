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
                    Text("Focusing")
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

                Button("Complete Task") {
                    focusVM.completeFocus()
                }

                Button("Cancel") {
                    focusVM.cancelFocus()
                }
            } else {
                Text("Lyubishchev")
                    .font(.headline)
                Text("No active task")
                    .foregroundStyle(.secondary)
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(12)
        .frame(width: 220)
    }
}
