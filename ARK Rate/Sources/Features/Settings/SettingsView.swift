import SwiftUI
import ComposableArchitecture

struct SettingsView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<SettingsFeature>

    // MARK: - Body

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.types, id: \.self) { type in
                    switch type {
                    case .changeAppLanguage: makeSettingItem(from: type, action: { store.send(.goToSettings) })
                    case .about: makeSettingItem(from: type, action: { store.send(.showAboutScreen) })
                    }
                }
            }
            .listStyle(.plain)
            .background(Color.backgroundPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(StringResource.title.localized)
            .navigationDestination(
                item: $store.scope(state: \.destination?.about, action: \.destination.about)
            ) { store in
                AboutView(store: store)
            }
            .onAppear {
                store.send(.showTabbar)
            }
        }
    }
}

// MARK: -

private extension SettingsView {

    func makeSettingItem(from type: SettingItemType, action: @escaping ButtonAction) -> some View {
        Button(action: action) {
            Text(type.title)
                .padding(.vertical, Constants.spacing)
        }
    }
}

// MARK: - Constants

private extension SettingsView {

    enum Constants {
        static let spacing: CGFloat = 8
    }

    enum StringResource: String.LocalizationValue {
        case title = "settings_title"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
