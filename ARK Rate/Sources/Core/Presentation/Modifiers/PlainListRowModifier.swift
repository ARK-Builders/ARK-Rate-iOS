import SwiftUI

struct PlainListRowModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
    }
}
