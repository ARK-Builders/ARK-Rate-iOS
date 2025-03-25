import ComposableArchitecture

@Reducer
struct CurrenciesFeature {

    @ObservableState
    struct State: Equatable {}

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
        default: Effect.none
        }
    }
}

// MARK: - Implementation

private extension CurrenciesFeature {

    func fetchCurrencies(_ state: inout State) -> Effect<Action> {
        Effect.run { send in
            for await currencies in fetchCurrenciesUseCase.execute() {
                let currencies = currencies.map { CurrencyDisplayModel(from: $0) }
                await send(Action.currenciesUpdated(currencies))
            }
        }
    }
}
