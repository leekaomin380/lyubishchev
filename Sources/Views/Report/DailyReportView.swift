import SwiftUI

struct DailyReportView: View {
    @Bindable var reportVM: ReportViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Date navigation
            HStack {
                Button {
                    reportVM.previousDay()
                } label: {
                    Image(systemName: "chevron.left")
                }

                Text(reportVM.formattedDate)
                    .font(.headline)
                    .frame(maxWidth: .infinity)

                Button {
                    reportVM.nextDay()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            Divider()

            if reportVM.entries.isEmpty {
                ContentUnavailableView {
                    Label("暂无记录", systemImage: "doc.text")
                } description: {
                    Text("当天没有时间记录。")
                }
            } else {
                List {
                    ForEach(reportVM.entries) { entry in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.taskTitle)
                                    .font(.body)
                                Text(entry.categoryName)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(entry.formattedTimeRange)
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                                Text(entry.formattedDuration)
                                    .font(.body.monospacedDigit())
                            }
                        }
                        .padding(.vertical, 2)
                    }

                    Section {
                        HStack {
                            Text("合计")
                                .font(.headline)
                            Spacer()
                            Text(reportVM.formattedTotalDuration)
                                .font(.headline.monospacedDigit())
                        }
                    }
                }
            }

            Divider()

            // Copy report button
            HStack {
                Spacer()
                Button {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(reportVM.reportText, forType: .string)
                } label: {
                    Label("复制日报", systemImage: "doc.on.doc")
                }
                .padding()
            }
        }
        .navigationTitle("日报")
        .onAppear { reportVM.refresh() }
    }
}
