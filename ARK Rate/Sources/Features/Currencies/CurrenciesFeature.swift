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
        case currenciesUpdated([Currency])
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
                await send(Action.currenciesUpdated(currencies))
            }
        }
    }

    func currenciesUpdated(_ state: inout State, _ currencies: [Currency]) -> Effect<Action> {
        let displayModels = currencies.map { CurrencyDisplayModel(from: $0) }
        state.currencies = displayModels
        state.isLoading = false
        return Effect.none
    }
}
