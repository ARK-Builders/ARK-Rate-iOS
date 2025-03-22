import SwiftUI

struct LineDivider: View {

    // MARK: - Properties

    let color: Color

    // MARK: - Initialization

    init(color: Color = Color.borderSecondary) {
        self.color = color
    }

    // MARK: - Body

    var body: some View {
        Divider()
            .frame(height: 1)
            .background(color)
    }
}
