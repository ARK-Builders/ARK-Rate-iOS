import SwiftUI

struct PrimaryButton: View {

    // MARK: - Properties

    let title: String
    let icon: Image?
    let action: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        icon: Image? = nil,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon = icon {
                    icon
                        .renderingMode(.template)
                        .foregroundColor(.white)
                }
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(Font.customInterSemiBold(size: 16))
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .foregroundColor(.white)
        .background(Color.brandSolid)
        .cornerRadius(8)
    }
}
