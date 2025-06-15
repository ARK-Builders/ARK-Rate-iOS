import SwiftUI

extension Image {

    @ViewBuilder
    func adaptToColorScheme(
        _ colorScheme: ColorScheme,
        foregroundColor: Color = Color.white
    ) -> some View {
        if colorScheme == .dark {
            self
                .renderingMode(.template)
                .foregroundColor(foregroundColor)
        } else {
            self
        }
    }
}
