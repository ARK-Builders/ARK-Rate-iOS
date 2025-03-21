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
            CurrencyRowView(currencyName: currency.id, currencyRate: currency.formattedRate)
        }
        .refreshable {
            store.send(.fetchCurrencies)
        }
    }
}
