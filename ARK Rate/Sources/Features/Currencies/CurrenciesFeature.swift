import ComposableArchitecture

@Reducer
struct CurrenciesFeature {

    @ObservableState
    struct State: Equatable {
        var isLoading = false
        var fiatCurrencies: [CurrencyDisplayModel] = []
    }

    enum Action {
        case fetchFiatCurrencies
        case fiatCurrenciesLoaded([FiatCurrency])
    }

    // MARK: - Properties

    @Dependency(\.fetchCurrenciesUseCase) var fetchCurrenciesUseCase

    // MARK: - Reducer

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchFiatCurrencies: fetchFiatCurrencies(&state)
        case .fiatCurrenciesLoaded(let fiatCurrencies): fiatCurrenciesLoaded(&state, fiatCurrencies)
        }
    }
}

// MARK: - Implementation

private extension CurrenciesFeature {

    func fetchFiatCurrencies(_ state: inout State) -> Effect<Action> {
        state.isLoading = true
        return Effect.run { send in
            var fiatCurrencies: [FiatCurrency] = []
            fiatCurrencies = try await fetchCurrenciesUseCase.fetchFiatCurrencies()
            await send(Action.fiatCurrenciesLoaded(fiatCurrencies))
        }
    }

    func fiatCurrenciesLoaded(_ state: inout State, _ fiatCurrencies: [FiatCurrency]) -> Effect<Action> {
        let displayModels = fiatCurrencies.map { CurrencyDisplayModel(from: $0) }
        state.fiatCurrencies = displayModels
        state.isLoading = false
        return Effect.none
    }
}
