import ComposableArchitecture

@Reducer
struct SearchACurrencyFeature {

    @ObservableState
    struct State: Equatable {
        var searchText = ""
        var currencies: [CurrencyDisplayModel] = []
        var allCurrencies: [CurrencyDisplayModel] = []
        var frequentCurrencies: [CurrencyDisplayModel] = []
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies
        case loadFrequentCurrencies
        case searchTextUpdated(String)
        case currencyCodeSelected(String)

        enum Delegate: Equatable {
            case back
            case currencyCodeDidSelect(String)
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase
    @Dependency(\.loadFrequentCurrenciesUseCase) var loadFrequentCurrenciesUseCase

    // MARK: - Reducer

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .backButtonTapped: backButtonTapped()
        case .loadCurrencies: loadCurrencies(&state)
        case .loadFrequentCurrencies: loadFrequentCurrencies(&state)
        case .searchTextUpdated(let searchText): searchTextUpdated(&state, searchText)
        case .currencyCodeSelected(let code): currencyCodeSelected(&state, code)
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
        let currencies = loadCurrenciesUseCase.getLocal()
            .map(\.toCurrencyDisplayModel)
        state.currencies = currencies
        state.allCurrencies = currencies
        return Effect.none
    }

    func loadFrequentCurrencies(_ state: inout State) -> Effect<Action> {
        state.frequentCurrencies = loadFrequentCurrenciesUseCase.execute()
            .map(\.toCurrencyDisplayModel)
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

    func currencyCodeSelected(_ state: inout State, _ code: String) -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.currencyCodeDidSelect(code)))
            await back()
        }
    }
}
