import ComposableArchitecture

@Reducer
struct CurrenciesFeature {

    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var currencies: [CurrencyDisplayModel] = []
    }

    enum Action {
        case fetchCurrencies
        case currenciesUpdated([CurrencyDisplayModel])
    }

    // MARK: - Properties

    @Dependency(\.fetchCurrenciesUseCase) var fetchCurrenciesUseCase

    // MARK: - Reducer

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchCurrencies: fetchCurrencies(&state)
        case .currenciesUpdated(let currencies): currenciesUpdated(&state, currencies)
        }
    }
}

// MARK: - Implementation

private extension CurrenciesFeature {

    func fetchCurrencies(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return Effect.run { send in
            for await currencies in fetchCurrenciesUseCase.execute() {
                let currencies = currencies.map { CurrencyDisplayModel(from: $0) }
                await send(Action.currenciesUpdated(currencies))
            }
        }
    }

    func currenciesUpdated(_ state: inout State, _ currencies: [CurrencyDisplayModel]) -> Effect<Action> {
        state.currencies = currencies
        state.isLoading = false
        return Effect.none
    }
}
