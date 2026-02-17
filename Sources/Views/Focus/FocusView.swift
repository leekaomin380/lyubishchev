import SwiftUI

struct FocusView: View {
    @Bindable var focusVM: FocusViewModel

    var body: some View {
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()

            // Subtle radial gradient
            RadialGradient(
                colors: [Color.red.opacity(0.08), Color.clear],
                center: .center,
                startRadius: 100,
                endRadius: 400
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // ON AIR indicator
                OnAirIndicator()

                // Task name
                Text(focusVM.currentItem?.title ?? "")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Start time
                Text("Started at \(focusVM.startTimeString)")
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.6))

                // Elapsed time (large)
                Text(focusVM.formattedElapsedTime)
                    .font(.system(size: 72, weight: .thin, design: .monospaced))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText())

                Spacer()

                // Action buttons
                HStack(spacing: 24) {
                    Button {
                        focusVM.cancelFocus()
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.8))
                            .frame(width: 120, height: 44)
                            .background(.white.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)

                    Button {
                        focusVM.completeFocus()
                    } label: {
                        Text("Complete")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 160, height: 50)
                            .background(.red, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                Spacer()
                    .frame(height: 40)
            }
        }
    }
}
