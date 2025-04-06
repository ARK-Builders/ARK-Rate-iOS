import SwiftUI

struct PlainListRowModifier: ViewModifier {

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
    }
}
