import SwiftUI
import ComposableArchitecture

struct SearchACurrencyView: View {

    // MARK: - Properties

    let store: StoreOf<SearchACurrencyFeature>

    // MARK: - Body

    var body: some View {
        VStack {
            list
        }
        .background(Color.backgroundPrimary)
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
        .onAppear {
            store.send(.loadCurrencies)
        }
    }
}

// MARK: -

private extension SearchACurrencyView {

    var list: some View {
        List(store.curriences, id: \.id) { currency in
            CurrencyRowView(
                code: currency.id,
                name: currency.name,
                rate: currency.formattedRate
            )
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
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
