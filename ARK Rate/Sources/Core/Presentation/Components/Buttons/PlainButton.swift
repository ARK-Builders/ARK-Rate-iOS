import SwiftUI

struct PlainButton<Content: View>: View {

    // MARK: - Properties

    let action: ButtonAction
    @ViewBuilder let label: () -> Content

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            label()
                .expandHitArea()
        }
        .buttonStyle(.plain)
    }
}
