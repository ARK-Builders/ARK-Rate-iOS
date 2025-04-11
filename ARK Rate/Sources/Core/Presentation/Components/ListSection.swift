import SwiftUI

struct ListSection<Content: View>: View {

    // MARK: - Properties

    let title: String
    @ViewBuilder let content: () -> Content

    // MARK: - Body

    var body: some View {
        Section(
            header: Text(title)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterMedium(size: 14))
        ) {
            content()
        }
    }
}
