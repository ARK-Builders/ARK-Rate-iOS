import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var currencies: [CurrencyDisplayModel] = []
        var exchangePairs: [ExchangePair] = []
    }

    enum Action {
        case currenciesUpdated([CurrencyDisplayModel])
        case addNewCalculationButtonTapped
        case hideTabbar
        case showTabbar
        case loadExchangePairs
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.exchangePairRepository) var exchangePairRepository

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .currenciesUpdated(let currencies): currenciesUpdated(&state, currencies)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .loadExchangePairs: loadExchangePairs(&state)
            case .destination(.presented(.addNewCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func currenciesUpdated(_ state: inout State, _ currencies: [CurrencyDisplayModel]) -> Effect<Action> {
        state.currencies = currencies
        return Effect.none
    }

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addNewCalculation(AddNewCalculationFeature.State())
        return .send(.hideTabbar)
    }

    func loadExchangePairs(_ state: inout State) -> Effect<Action> {
        do {
            state.exchangePairs = try exchangePairRepository.get()
            print(state.exchangePairs)
        } catch {}
        return Effect.none
    }
}

// MARK: -

extension QuickFeature {

    @Reducer
    enum Destination {
        case addNewCalculation(AddNewCalculationFeature)
    }
}

// MARK: -

extension QuickFeature.Destination.State: Equatable {}
