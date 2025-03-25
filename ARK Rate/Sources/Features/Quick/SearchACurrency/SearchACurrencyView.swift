import SwiftUI
import ComposableArchitecture

struct SearchACurrencyView: View {

    // MARK: - Properties

    let store: StoreOf<SearchACurrencyFeature>

    // MARK: - Body

    var body: some View {
        VStack {
            List {
                allCurrenciesSection
            }
            .listStyle(.plain)
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

    var allCurrenciesSection: some View {
        Section(header: Text(StringResource.allCurrencies.localized)
            .foregroundColor(Color.textTertiary)
            .font(Font.customInterMedium(size: 14))
        ) {
            ForEach(store.curriences, id: \.id) { currency in
                CurrencyRowView(
                    code: currency.id,
                    name: currency.name,
                    rate: currency.formattedRate
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
    }
}

// MARK: - Constants

private extension SearchACurrencyView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "search_a_currency"
        case allCurrencies = "all_currencies"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
