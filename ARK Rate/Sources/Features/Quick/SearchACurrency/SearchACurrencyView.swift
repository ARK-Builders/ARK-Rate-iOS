import SwiftUI
import SwiftUIX
import ComposableArchitecture

struct SearchACurrencyView: View {

    // MARK: - Properties

    @State var isSearching = false

    @Binding var store: StoreOf<SearchACurrencyFeature>

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            searchBar
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

    var searchBar: some View {
        SearchBar(
            StringResource.search.localized,
            text: $store.searchText.sending(\.searchTextUpdated),
            isEditing: $isSearching
        )
        .showsCancelButton(isSearching)
        .textFieldBackgroundColor(Color.backgroundPrimary)
        .padding(.horizontal, Constants.spacing)
    }

    var allCurrenciesSection: some View {
        Section(header: Text(StringResource.allCurrencies.localized)
            .foregroundColor(Color.textTertiary)
            .font(Font.customInterMedium(size: 14))
        ) {
            ForEach(store.currencies, id: \.id) { currency in
                CurrencyRowView(
                    code: currency.id,
                    name: currency.name,
                    action: { store.send(.currencyCodeSelected(currency.id)) }
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
        case search = "Search"
        case allCurrencies = "all_currencies"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
