import SwiftUI
import SwiftData

@main
struct LyubishchevApp: App {
    @State private var todoVM = TodoViewModel()
    @State private var focusVM = FocusViewModel()
    @State private var statsVM = StatisticsViewModel()
    @State private var reportVM = ReportViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TodoItem.self,
            TaskCategory.self,
            TimeRecord.self
        ])
        let config = ModelConfiguration("Lyubishchev", isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        // Main window
        WindowGroup {
            ContentView(
                todoVM: todoVM,
                focusVM: focusVM,
                statsVM: statsVM,
                reportVM: reportVM
            )
            .modelContainer(sharedModelContainer)
            .onAppear {
                let context = sharedModelContainer.mainContext
                todoVM.modelContext = context
                focusVM.modelContext = context
                statsVM.modelContext = context
                reportVM.modelContext = context
            }
            .frame(minWidth: 700, minHeight: 500)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 900, height: 600)

        // Menu bar extra
        MenuBarExtra {
            MenuBarView(focusVM: focusVM)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: focusVM.isActive ? "record.circle" : "clock")
                if focusVM.isActive {
                    Text(focusVM.menuBarTitle)
                }
            }
        }
        .menuBarExtraStyle(.window)
    }
}
