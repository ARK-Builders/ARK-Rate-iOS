import SwiftUI
import ComposableArchitecture

struct SearchACurrencyView: View {

    // MARK: - Properties

    let store: StoreOf<SearchACurrencyFeature>

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

private extension SearchACurrencyView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "search_a_currency"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
