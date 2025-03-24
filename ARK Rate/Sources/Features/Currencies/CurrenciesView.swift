import SwiftUI
import SwiftUIX
import ComposableArchitecture

struct CurrenciesView: View {

    // MARK: - Properties

    let store: StoreOf<CurrenciesFeature>

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack {
                list
            }
            .loadingOverlay(store.isLoading)
            .onAppear {
                store.send(.fetchCurrencies)
            }
            .navigationTitle("Currencies")
        }
    }
}

private extension CurrenciesView {

    var list: some View {
        List(store.currencies, id: \.id) { currency in
            CurrencyRowView(code: currency.id, rate: currency.formattedRate)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .refreshable {
            store.send(.fetchCurrencies)
        }
    }
}
