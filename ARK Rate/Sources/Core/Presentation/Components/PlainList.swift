import SwiftUI

struct PlainList<Content: View>: View {

    // MARK: - Properties

    @ViewBuilder let content: () -> Content

    // MARK: - Body

    var body: some View {
        List {
            content()
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}
