import ComposableArchitecture

@Reducer
struct SearchACurrencyFeature {

    @ObservableState
    struct State: Equatable {
        var searchText = ""
        var currencies: [CurrencyDisplayModel] = []
        var allCurrencies: [CurrencyDisplayModel] = []
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies
        case searchTextUpdated(String)

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
        case .searchTextUpdated(let searchText): searchTextUpdated(&state, searchText)
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
        var currencies: [CurrencyDisplayModel] = []
        do {
            currencies = try currencyRepository.getLocal()
                .map { CurrencyDisplayModel(from: $0) }
        } catch {}
        state.currencies = currencies
        state.allCurrencies = currencies
        return Effect.none
    }

    func searchTextUpdated(_ state: inout State, _ searchText: String) -> Effect<Action> {
        state.searchText = searchText

        if searchText.isEmpty {
            state.currencies = state.allCurrencies
        } else {
            state.currencies = state.allCurrencies.filter {
                $0.id.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }

        return Effect.none
    }
}
