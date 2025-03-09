import SwiftUI

extension View {

    func loadingOverlay(_ isLoading: Bool) -> some View {
        modifier(LoadingOverlayModifier(isLoading: isLoading))
    }
}
