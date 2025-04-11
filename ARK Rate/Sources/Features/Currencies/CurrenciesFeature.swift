import ComposableArchitecture

@Reducer
struct CurrenciesFeature {

    @ObservableState
    struct State: Equatable {}

    enum Action {
        case fetchCurrencies
        case currenciesUpdated([Currency])
    }

    // MARK: - Properties

    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase

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
            for await currencies in loadCurrenciesUseCase.fetchRemote() {
                await send(.currenciesUpdated(currencies))
            }
        }
    }
}
