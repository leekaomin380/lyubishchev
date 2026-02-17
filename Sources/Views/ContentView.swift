import SwiftUI
import SwiftData

enum NavigationTab: String, Hashable {
    case tasks = "Tasks"
    case statistics = "Statistics"
    case report = "Daily Report"
}

struct ContentView: View {
    @Bindable var todoVM: TodoViewModel
    @Bindable var focusVM: FocusViewModel
    @Bindable var statsVM: StatisticsViewModel
    @Bindable var reportVM: ReportViewModel

    @State private var selectedTab: NavigationTab = .tasks

    var body: some View {
        ZStack {
            NavigationSplitView {
                VStack(spacing: 0) {
                    SidebarView(todoVM: todoVM)

                    Divider()

                    // Navigation tabs at bottom of sidebar
                    VStack(spacing: 4) {
                        SidebarButton(
                            title: "Tasks",
                            icon: "checklist",
                            isSelected: selectedTab == .tasks
                        ) { selectedTab = .tasks }

                        SidebarButton(
                            title: "Statistics",
                            icon: "chart.bar.fill",
                            isSelected: selectedTab == .statistics
                        ) { selectedTab = .statistics }

                        SidebarButton(
                            title: "Daily Report",
                            icon: "doc.text.fill",
                            isSelected: selectedTab == .report
                        ) { selectedTab = .report }
                    }
                    .padding(8)
                }
            } detail: {
                switch selectedTab {
                case .tasks:
                    TodoListView(todoVM: todoVM, focusVM: focusVM)
                case .statistics:
                    StatisticsView(statsVM: statsVM)
                case .report:
                    DailyReportView(reportVM: reportVM)
                }
            }
            .opacity(focusVM.isActive ? 0 : 1)

            // Focus mode overlay
            if focusVM.isActive {
                FocusView(focusVM: focusVM)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: focusVM.isActive)
    }
}

struct SidebarButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isSelected ? Color.accentColor.opacity(0.15) : Color.clear, in: RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}
