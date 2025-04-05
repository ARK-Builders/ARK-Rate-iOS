import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var currencies: [Currency] = []
        var quickCalculations: [QuickCalculationDisplayModel] = []
    }

    enum Action {
        case currenciesUpdated([Currency])
        case addNewCalculationButtonTapped
        case hideTabbar
        case showTabbar
        case loadQuickCalculations
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.quickCalculationRepository) var quickCalculationRepository
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .currenciesUpdated(let currencies): currenciesUpdated(&state, currencies)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .loadQuickCalculations: loadQuickCalculations(&state)
            case .destination(.presented(.addQuickCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func currenciesUpdated(_ state: inout State, _ currencies: [Currency]) -> Effect<Action> {
        state.currencies = currencies
        return Effect.none
    }

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addQuickCalculation(AddQuickCalculationFeature.State())
        return .send(.hideTabbar)
    }

    func loadQuickCalculations(_ state: inout State) -> Effect<Action> {
        do {
            let quickCalculations = try quickCalculationRepository.get()
            state.quickCalculations = quickCalculations.compactMap { calculation in
                guard let inputCurrency = state.currencies.first(where: { $0.code == calculation.inputCurrencyCode }) else { return nil }
                let outputCurrencies = state.currencies.filter { calculation.outputCurrenciesCode.contains($0.code) }
                guard !outputCurrencies.isEmpty else { return nil }
                let currencyAmounts = currencyCalculationUseCase.execute(
                    inputCurrency: inputCurrency,
                    inputCurrencyAmount: calculation.inputCurrencyAmount,
                    outputCurrencies: outputCurrencies
                )
                return QuickCalculationDisplayModel(
                    id: calculation.id,
                    calculatedDate: calculation.calculatedDate,
                    input: CurrencyDisplayModel(from: inputCurrency, amount: "\(calculation.inputCurrencyAmount)"),
                    outputs: outputCurrencies.map { CurrencyDisplayModel(from: $0, amount: currencyAmounts[$0.code] ?? "") }
                )
            }
        } catch {}
        return Effect.none
    }
}

// MARK: -

extension QuickFeature {

    @Reducer
    enum Destination {
        case addQuickCalculation(AddQuickCalculationFeature)
    }
}

// MARK: -

extension QuickFeature.Destination.State: Equatable {}
