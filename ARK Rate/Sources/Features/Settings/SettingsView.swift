import SwiftUI
import ComposableArchitecture

struct SettingsView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<SettingsFeature>

    // MARK: - Body

    var body: some View {
        VStack {
            Text(StringResource.title.localized)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundPrimary)
        .onAppear {
            store.send(.showTabbar)
        }
    }
}

// MARK: - Constants

private extension SettingsView {

    enum StringResource: String.LocalizationValue {
        case title = "settings_title"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
