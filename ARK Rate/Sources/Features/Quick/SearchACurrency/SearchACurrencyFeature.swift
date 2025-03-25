import ComposableArchitecture

@Reducer
struct SearchACurrencyFeature {

    @ObservableState
    struct State: Equatable {
        var curriences: [CurrencyDisplayModel] = []
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies

        enum Delegate: Equatable {
            case back
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.currencyRepository) var currencyRepository

    // MARK: - Reducer

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .backButtonTapped: backButtonTapped()
        case .loadCurrencies: loadCurrencies(&state)
        default: Effect.none
        }
    }
}

// MARK: - Implementation

private extension SearchACurrencyFeature {

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        var curriences: [CurrencyDisplayModel] = []
        do {
            curriences = try currencyRepository.getLocal()
                .map { CurrencyDisplayModel(from: $0) }
        } catch {}
        state.curriences = curriences
        return Effect.none
    }
}
