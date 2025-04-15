import Foundation
import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var searchText = String.empty
        var selectedCalculation: QuickCalculationDisplayModel?
        var pinnedCalculations: IdentifiedArrayOf<QuickCalculationDisplayModel> = []
        var calculatedCalculations: IdentifiedArrayOf<QuickCalculationDisplayModel> = []
        var allCurrencies: [CurrencyDisplayModel] = []
        var frequentCurrencies: [CurrencyDisplayModel] = []
        var displayingCurrencies: [CurrencyDisplayModel] = []

        var isSearching: Bool {
            !searchText.isTrimmedEmpty
        }
    }

    enum Action {
        case loadListContent
        case loadPinnedCalculations
        case loadCalculatedCalculations
        case loadCurrencies
        case loadFrequentCurrencies
        case currenciesUpdated([Currency])
        case addNewCalculationButtonTapped
        case togglePinnedButtonTapped(id: UUID)
        case calculationItemSelected(QuickCalculationDisplayModel?)
        case searchTextUpdated(String)
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
            case .loadListContent: loadListContent(&state)
            case .loadPinnedCalculations: loadPinnedCalculations(&state)
            case .loadCalculatedCalculations: loadCalculatedCalculations(&state)
            case .loadCurrencies: loadCurrencies(&state)
            case .loadFrequentCurrencies: loadFrequentCurrencies(&state)
            case .currenciesUpdated: .send(.loadPinnedCalculations)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .togglePinnedButtonTapped(let id): togglePinnedButtonTapped(&state, id)
            case .calculationItemSelected(let calculation): calculationItemSelected(&state, calculation)
            case .searchTextUpdated(let searchText): searchTextUpdated(&state, searchText)
            case .destination(.presented(.addQuickCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func loadListContent(_ state: inout State) -> Effect<Action> {
        state.pinnedCalculations = IdentifiedArrayOf(uniqueElements: getPinnedCalculations())
        state.calculatedCalculations = IdentifiedArrayOf(uniqueElements: getCalculatedCalculations())
        if !state.calculatedCalculations.isEmpty || !state.pinnedCalculations.isEmpty {
            return Effect.merge(
                .send(.loadCurrencies),
                .send(.loadFrequentCurrencies)
            )
        } else {
            return Effect.none
        }
    }

    func loadPinnedCalculations(_ state: inout State) -> Effect<Action> {
        state.pinnedCalculations = IdentifiedArrayOf(uniqueElements: getPinnedCalculations())
        return Effect.none
    }

    func loadCalculatedCalculations(_ state: inout State) -> Effect<Action> {
        state.calculatedCalculations = IdentifiedArrayOf(uniqueElements: getCalculatedCalculations())
        return Effect.none
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        state.allCurrencies = loadCurrenciesUseCase.getLocal()
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
        togglePinnedCalculationUseCase.execute(id)
        return Effect.merge(
            .send(.loadPinnedCalculations),
            .send(.loadCalculatedCalculations)
        )
    }

    func calculationItemSelected(_ state: inout State, _ calculation: QuickCalculationDisplayModel?) -> Effect<Action> {
        state.selectedCalculation = calculation
        return Effect.none
    }

    func searchTextUpdated(_ state: inout State, _ searchText: String) -> Effect<Action> {
        state.searchText = searchText
        state.displayingCurrencies = state.isSearching ? state.allCurrencies.filter {
            $0.id.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        } : []
        return Effect.none
    }
}

// MARK: - Helpers

private extension QuickFeature {

    func getPinnedCalculations() -> [QuickCalculationDisplayModel] {
        loadQuickCalculationsUseCase.getPinnedCalculations()
            .map(\.toQuickCalculationDisplayModel)
    }

    func getCalculatedCalculations() -> [QuickCalculationDisplayModel] {
        loadQuickCalculationsUseCase.getCalculatedCalculations()
            .map(\.toQuickCalculationDisplayModel)
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
