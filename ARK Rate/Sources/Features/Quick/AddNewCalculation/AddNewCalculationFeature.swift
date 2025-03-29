import ComposableArchitecture

@Reducer
struct AddNewCalculationFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var fromCurrency = AddingCurrencyDisplayModel(code: Constants.defaultFromCurrencyCode)
        var toCurrencies: [AddingCurrencyDisplayModel] = []
        var currencies: [Currency] = []
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies
        case selectFromCurrency
        case updateFromCurrencyAmount(amount: String)
        case selectToCurrency(index: Int)
        case updateToCurrencyAmount(index: Int, amount: String)
        case addNewCurrencyButtonTapped
        case destination(PresentationAction<Destination.Action>)

        enum Delegate: Equatable {
            case back
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.currencyRepository) var currencyRepository

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped: backButtonTapped()
            case .loadCurrencies: loadCurrencies(&state)
            case .selectFromCurrency: selectFromCurrency(&state)
            case .updateFromCurrencyAmount(let amount): updateFromCurrencyAmount(&state, amount)
            case .updateToCurrencyAmount(let index, let amount): updateToCurrencyAmount(&state, amount, index)
            case .addNewCurrencyButtonTapped: addNewCurrencyButtonTapped(&state)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension AddNewCalculationFeature {

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        var currencies: [Currency] = []
        do {
            currencies = try currencyRepository
                .getLocal()
        } catch {}
        state.currencies = currencies
        return Effect.none
    }

    func selectFromCurrency(_ state: inout State) -> Effect<Action> {
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateFromCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.fromCurrency.amount = amount
        return Effect.none
    }

    func updateToCurrencyAmount(_ state: inout State, _ amount: String, _ index: Int) -> Effect<Action> {
        state.toCurrencies[index].amount = amount
        return Effect.none
    }

    func addNewCurrencyButtonTapped(_ state: inout State) -> Effect<Action> {
        state.toCurrencies.append(AddingCurrencyDisplayModel())
        return Effect.none
    }
}

// MARK: -

extension AddNewCalculationFeature {

    @Reducer
    enum Destination {
        case searchACurrency(SearchACurrencyFeature)
    }
}

// MARK: -

extension AddNewCalculationFeature.Destination.State: Equatable {}

// MARK: - Constants

private extension AddNewCalculationFeature {

    enum Constants {
        static let defaultFromCurrencyCode = "USD"
    }
}
