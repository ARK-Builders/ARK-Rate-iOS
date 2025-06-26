import SwiftUI
import ComposableArchitecture

struct AboutView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<AboutFeature>

    // MARK: - Body

    var body: some View {
        VStack {

        }
        .background(Color.backgroundPrimary)
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
    }
}

// MARK: - Constants

private extension AboutView {

    enum StringResource: String.LocalizationValue {
        case title = "about_title"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
