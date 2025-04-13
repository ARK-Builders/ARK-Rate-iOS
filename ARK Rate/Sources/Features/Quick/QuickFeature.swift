import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var frequentCurrencies: [CurrencyDisplayModel] = []
        var displayingCurrencies: [CurrencyDisplayModel] = []
        var calculatedCalculations: [QuickCalculationDisplayModel] = []
    }

    enum Action {
        case loadQuickCalculations
        case loadCurrencies
        case loadFrequentCurrencies
        case currenciesUpdated([Currency])
        case addNewCalculationButtonTapped
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.loadQuickCalculationsUseCase) var loadQuickCalculationsUseCase
    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase
    @Dependency(\.loadFrequentCurrenciesUseCase) var loadFrequentCurrenciesUseCase
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadQuickCalculations: loadQuickCalculations(&state)
            case .loadCurrencies: loadCurrencies(&state)
            case .loadFrequentCurrencies: loadFrequentCurrencies(&state)
            case .currenciesUpdated: .send(.loadQuickCalculations)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .destination(.presented(.addQuickCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func loadQuickCalculations(_ state: inout State) -> Effect<Action> {
        state.calculatedCalculations = loadQuickCalculationsUseCase.getCalculatedCalculations().map { calculation in
            QuickCalculationDisplayModel(
                id: calculation.id,
                calculatedDate: calculation.calculatedDate,
                input: CurrencyDisplayModel(
                    code: calculation.inputCurrencyCode,
                    amount: calculation.inputCurrencyAmount
                ),
                outputs: zip(calculation.outputCurrencyCodes, calculation.outputCurrencyAmounts).map { code, amount in
                    CurrencyDisplayModel(code: code, amount: amount)
                }
            )
        }
        if !state.calculatedCalculations.isEmpty {
            return Effect.merge(
                .send(.loadCurrencies),
                .send(.loadFrequentCurrencies)
            )
        } else {
            return Effect.none
        }
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        state.displayingCurrencies = loadCurrenciesUseCase.getLocal().map { CurrencyDisplayModel(code: $0.code) }
        return Effect.none
    }

    func loadFrequentCurrencies(_ state: inout State) -> Effect<Action> {
        state.frequentCurrencies = loadFrequentCurrenciesUseCase.execute()
            .map { CurrencyDisplayModel(code: $0.code) }
        return Effect.none
    }

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addQuickCalculation(AddQuickCalculationFeature.State())
        return .send(.hideTabbar)
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
