import SwiftUI
import SwiftUIX
import ComposableArchitecture

struct SearchACurrencyView: View {

    // MARK: - Properties

    @State var isSearchBarEditing = false
    @Binding var store: StoreOf<SearchACurrencyFeature>

    // MARK: - Body

    var body: some View {
        content
        .background(Color.backgroundPrimary)
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
        .onAppear {
            store.send(.loadCurrencies)
            store.send(.loadFrequentCurrencies)
        }
    }
}

// MARK: -

private extension SearchACurrencyView {

    var content: some View {
        VStack(spacing: 0) {
            searchBar
            contentListView
        }
    }

    var searchBar: some View {
        SearchBar(
            StringResource.search.localized,
            text: $store.searchText.sending(\.searchTextUpdated),
            isEditing: $isSearchBarEditing
        )
        .showsCancelButton(isSearchBarEditing)
        .textFieldBackgroundColor(Color.backgroundPrimary)
        .padding(.horizontal, Constants.spacing)
    }

    var contentListView: some View {
        ZStack {
            List {
                if !store.isSearching {
                    frequentCurrenciesSection
                    allCurrenciesSection
                } else {
                    searchingCurrenciesSection
                }
            }
            .listStyle(.plain)
            if store.isSearching && store.displayingCurrencies.isEmpty {
                CurrencyEmptyStateView()
            }
        }
    }

    @ViewBuilder
    var frequentCurrenciesSection: some View {
        if !store.frequentCurrencies.isEmpty {
            ListSection(title: StringResource.frequentCurrencies.localized) {
                ForEach(store.frequentCurrencies, id: \.id) { currency in
                    CurrencyRowView(
                        code: currency.id,
                        name: currency.name,
                        action: { store.send(.currencyCodeSelected(currency.id)) }
                    )
                    .modifier(PlainListRowModifier())
                }
            }
        }
    }

    var allCurrenciesSection: some View {
        ListSection(title: StringResource.allCurrencies.localized) {
            ForEach(store.allCurrencies, id: \.id) { currency in
                CurrencyRowView(
                    code: currency.id,
                    name: currency.name,
                    action: { store.send(.currencyCodeSelected(currency.id)) }
                )
                .modifier(PlainListRowModifier())
            }
        }
    }

    @ViewBuilder
    var searchingCurrenciesSection: some View {
        if !store.displayingCurrencies.isEmpty {
            ListSection(title: StringResource.topResults.localized) {
                ForEach(store.displayingCurrencies, id: \.id) { currency in
                    CurrencyRowView(
                        code: currency.id,
                        name: currency.name,
                        action: {}
                    )
                    .modifier(PlainListRowModifier())
                }
            }
        }
    }
}

// MARK: - Constants

private extension SearchACurrencyView {

    enum Constants {
        static let spacing: CGFloat = 8
    }

    enum StringResource: String.LocalizationValue {
        case title = "search_a_currency"
        case search
        case allCurrencies = "all_currencies"
        case frequentCurrencies = "frequent_currencies"
        case topResults = "top_results"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
