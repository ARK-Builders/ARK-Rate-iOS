import Foundation
import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var pinnedCalculations: [QuickCalculationDisplayModel] = []
        var calculatedCalculations: IdentifiedArrayOf<QuickCalculationDisplayModel> = []
        var frequentCurrencies: [CurrencyDisplayModel] = []
        var displayingCurrencies: [CurrencyDisplayModel] = []
    }

    enum Action {
        case loadCalculatedCalculations
        case loadPinnedCalculations
        case loadCurrencies
        case loadFrequentCurrencies
        case currenciesUpdated([Currency])
        case addNewCalculationButtonTapped
        case togglePinnedButtonTapped(id: UUID)
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.loadQuickCalculationsUseCase) var loadQuickCalculationsUseCase
    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase
    @Dependency(\.loadFrequentCurrenciesUseCase) var loadFrequentCurrenciesUseCase
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase
    @Dependency(\.togglePinnedCalculationUseCase) var togglePinnedCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadCalculatedCalculations: loadCalculatedCalculations(&state)
            case .loadPinnedCalculations: loadPinnedCalculations(&state)
            case .loadCurrencies: loadCurrencies(&state)
            case .loadFrequentCurrencies: loadFrequentCurrencies(&state)
            case .currenciesUpdated: .send(.loadCalculatedCalculations)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .togglePinnedButtonTapped(let id): togglePinnedButtonTapped(&state, id)
            case .destination(.presented(.addQuickCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func loadCalculatedCalculations(_ state: inout State) -> Effect<Action> {
        let calculatedCalculations = loadQuickCalculationsUseCase.getCalculatedCalculations()
            .map(\.toQuickCalculationDisplayModel)
        state.calculatedCalculations = IdentifiedArrayOf(uniqueElements: calculatedCalculations)
        if !calculatedCalculations.isEmpty {
            return Effect.merge(
                .send(.loadPinnedCalculations),
                .send(.loadCurrencies),
                .send(.loadFrequentCurrencies)
            )
        } else {
            return Effect.none
        }
    }

    func loadPinnedCalculations(_ state: inout State) -> Effect<Action> {
        state.pinnedCalculations = loadQuickCalculationsUseCase.getPinnedCalculations()
            .map(\.toQuickCalculationDisplayModel)
        return Effect.none
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        state.displayingCurrencies = loadCurrenciesUseCase.getLocal()
            .map(\.toCurrencyDisplayModel)
        return Effect.none
    }

    func loadFrequentCurrencies(_ state: inout State) -> Effect<Action> {
        state.frequentCurrencies = loadFrequentCurrenciesUseCase.execute()
            .map(\.toCurrencyDisplayModel)
        return Effect.none
    }

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addQuickCalculation(AddQuickCalculationFeature.State())
        return .send(.hideTabbar)
    }

    func togglePinnedButtonTapped(_ state: inout State, _ id: UUID) -> Effect<Action> {
        if let calculation = togglePinnedCalculationUseCase.execute(id),
           let index = state.calculatedCalculations.index(id: id) {
            state.calculatedCalculations[index] = calculation.toQuickCalculationDisplayModel
        }
        return .send(.loadPinnedCalculations)
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
