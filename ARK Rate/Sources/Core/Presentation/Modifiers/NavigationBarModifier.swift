import SwiftUI

struct NavigationBarModifier: ViewModifier {

    // MARK: - Properties

    let title: String
    let disabled: Bool
    let backButtonAction: ButtonAction

    // MARK: - Initialization

    init(
        title: String,
        disabled: Bool = false,
        backButtonAction: @escaping ButtonAction
    ) {
        self.title = title
        self.disabled = disabled
        self.backButtonAction = backButtonAction
    }

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: backButtonAction) {
                        Image.chevronLeft
                            .foregroundColor(Color.textPrimary)
                    }
                    .modifier(DisabledModifier(disabled: disabled, disabledOpacity: 0.2))
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .foregroundColor(Color.textPrimary)
                        .font(Font.customInterSemiBold(size: 20))
                        .modifier(DisabledModifier(disabled: disabled, disabledOpacity: 0.2))
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}
