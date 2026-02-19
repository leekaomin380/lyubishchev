import SwiftUI

struct OnAirIndicator: View {
    @State private var isGlowing = false

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(.red.opacity(0.3))
                .frame(width: 60, height: 60)
                .blur(radius: isGlowing ? 20 : 10)
                .scaleEffect(isGlowing ? 1.3 : 1.0)

            // Mid glow
            Circle()
                .fill(.red.opacity(0.5))
                .frame(width: 40, height: 40)
                .blur(radius: isGlowing ? 10 : 5)

            // Core light
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .red],
                        center: .center,
                        startRadius: 2,
                        endRadius: 15
                    )
                )
                .frame(width: 24, height: 24)
                .shadow(color: .red, radius: isGlowing ? 15 : 8)

            // ON AIR text
            Text("专注中")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundStyle(.red)
                .offset(y: 42)
                .opacity(isGlowing ? 1.0 : 0.6)
        }
        .frame(width: 80, height: 100)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isGlowing = true
            }
        }
    }
}
