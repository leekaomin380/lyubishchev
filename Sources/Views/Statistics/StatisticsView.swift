import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Bindable var statsVM: StatisticsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Period picker
                Picker("时间范围", selection: $statsVM.selectedPeriod) {
                    ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: statsVM.selectedPeriod) {
                    statsVM.refresh()
                }

                // Summary cards
                HStack(spacing: 16) {
                    StatCard(title: "总时长", value: statsVM.formattedTotalDuration, icon: "clock.fill")
                    StatCard(title: "已完成", value: "\(statsVM.completedCount)", icon: "checkmark.circle.fill")
                }
                .padding(.horizontal)

                // Category breakdown
                if !statsVM.categoryStats.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("按分类")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(statsVM.categoryStats) { stat in
                            HStack {
                                Circle()
                                    .fill(Color(hex: stat.colorHex))
                                    .frame(width: 10, height: 10)
                                Text(stat.name)
                                Spacer()
                                Text(stat.formattedDuration)
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Daily breakdown
                if !statsVM.dailyStats.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("每日")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(statsVM.dailyStats) { stat in
                            HStack {
                                Text(stat.formattedDate)
                                    .monospacedDigit()

                                // Simple bar
                                GeometryReader { geo in
                                    let maxDuration = statsVM.dailyStats.map(\.totalDuration).max() ?? 1
                                    let width = max(4, geo.size.width * stat.totalDuration / maxDuration)
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(.red.opacity(0.7))
                                        .frame(width: width, height: 20)
                                }
                                .frame(height: 20)

                                Text(stat.formattedDuration)
                                    .monospacedDigit()
                                    .foregroundStyle(.secondary)
                                    .frame(width: 70, alignment: .trailing)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("统计")
        .onAppear { statsVM.refresh() }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.red)
            Text(value)
                .font(.title2.monospacedDigit().bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
