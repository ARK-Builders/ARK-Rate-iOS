import SwiftUI

extension View {

    var hasExtendedTopArea: Bool {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
            return false
        }
        return window.safeAreaInsets.top > 20
    }
}
