import SwiftUI

struct WiggleViewModifier: ViewModifier {

    // MARK: - Properties

    let amount: Double
    @State private var isWiggling = false

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(isWiggling ? amount : 0))
            .animation(
                .easeInOut(duration: randomize(interval: 0.14, withVariance: 0.025))
                .repeatForever(autoreverses: true),
                value: isWiggling
            )
            .animation(
                .easeInOut(duration: randomize(interval: 0.18, withVariance: 0.025))
                .repeatForever(autoreverses: true),
                value: isWiggling
            )
            .onAppear {
                isWiggling.toggle()
            }
    }

    // MARK: - Helpers

    private func randomize(interval: TimeInterval, withVariance variance: Double) -> TimeInterval {
         interval + variance * (Double.random(in: 500...1_000) / 500)
    }
}
