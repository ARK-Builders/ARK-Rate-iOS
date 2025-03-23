import SwiftUI

struct NavigationBarModifier: ViewModifier {

    // MARK: - Properties

    let title: String
    let backButtonAction: ButtonAction

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: backButtonAction) {
                        Image.chevronLeft
                            .foregroundColor(Color.textPrimary)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .foregroundColor(Color.textPrimary)
                        .font(Font.customInterSemiBold(size: 24))
                }
            }
            .navigationBarBackButtonHidden(true)
    }
}
