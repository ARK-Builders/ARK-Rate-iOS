import SwiftUI

struct LoadingOverlayModifier: ViewModifier {

    // MARK: - Properties

    let isLoading: Bool

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .overlay(
                isLoading ?
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .transition(.opacity)
                : nil
            )
    }
}
