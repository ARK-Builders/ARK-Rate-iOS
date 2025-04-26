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

        var deletedCalculations: [QuickCalculation] = []
        var toastMessages: IdentifiedArrayOf<QuickToastContext> = []

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
        case currencyCodeSelected(String)
        case togglePinnedButtonTapped(id: UUID?)
        case editCalculationButtonTapped(id: UUID?)
        case reuseCalculationButtonTapped(id: UUID?)
        case deleteCalculationButtonTapped(id: UUID?)
        case calculationItemSelected(QuickCalculationDisplayModel?)
        case searchTextUpdated(String)
        case showToastMessage(QuickToastContext)
        case clearToastMessage(QuickToastContext)
        case toastMessageActionButtonTapped(QuickToastContext)
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Constants

    private enum Constants {
        static let toastAppearDelay: UInt64 = 350_000_000
        static let toastAutoClearDelay: UInt64 = 10_000_000_000
    }

    // MARK: - Properties

    @Dependency(\.loadQuickCalculationsUseCase) var loadQuickCalculationsUseCase
    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase
    @Dependency(\.loadFrequentCurrenciesUseCase) var loadFrequentCurrenciesUseCase
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase
    @Dependency(\.togglePinnedCalculationUseCase) var togglePinnedCalculationUseCase
    @Dependency(\.quickCalculationRepository) var quickCalculationRepository

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
            case .currencyCodeSelected(let code): currencyCodeSelected(&state, code)
            case .togglePinnedButtonTapped(let id): togglePinnedButtonTapped(&state, id)
            case .editCalculationButtonTapped(let id): editCalculationButtonTapped(&state, id)
            case .reuseCalculationButtonTapped(let id): reuseCalculationButtonTapped(&state, id)
            case .deleteCalculationButtonTapped(let id): deleteCalculationButtonTapped(&state, id)
            case .calculationItemSelected(let calculation): calculationItemSelected(&state, calculation)
            case .searchTextUpdated(let searchText): searchTextUpdated(&state, searchText)
            case .showToastMessage(let context): showToastMessage(&state, context)
            case .clearToastMessage(let context): clearToastMessage(&state, context)
            case .toastMessageActionButtonTapped(let context): toastMessageActionButtonTapped(&state, context)
            case .destination(.presented(.addQuickCalculation(.delegate(let callback)))): onAddQuickCalculationCallback(&state, callback)
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

    func onAddQuickCalculationCallback(_ state: inout State, _ delegate: AddQuickCalculationFeature.Action.Delegate) -> Effect<Action> {
        let calculation: QuickCalculationDisplayModel
        let toastMessage: QuickToastContext
        switch delegate {
        case .added(let addedCalculation):
            calculation = addedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.added(calculation)
        case .edited(let editedCalculation):
            calculation = editedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.edited(calculation)
        case .reused(let reusedCalculation):
            calculation = reusedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.reused(calculation)
        default: return Effect.none
        }
        return Effect.merge(
            .send(.loadPinnedCalculations),
            .send(.loadCalculatedCalculations),
            .run { send in
                try? await Task.sleep(nanoseconds: Constants.toastAppearDelay)
                await send(.showToastMessage(toastMessage))
            }
        )
    }

    func currencyCodeSelected(_ state: inout State, _ code: String) -> Effect<Action> {
        let featureState = AddQuickCalculationFeature.State(usageMode: .add(code: code))
        state.destination = .addQuickCalculation(featureState)
        return .send(.hideTabbar)
    }

    func togglePinnedButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id else { return Effect.none }
        togglePinnedCalculationUseCase.execute(id)
        return Effect.merge(
            .send(.loadPinnedCalculations),
            .send(.loadCalculatedCalculations)
        )
    }

    func editCalculationButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id else { return Effect.none }
        let featureState = AddQuickCalculationFeature.State(usageMode: .edit(calculationId: id))
        state.destination = .addQuickCalculation(featureState)
        return .send(.hideTabbar)
    }

    func reuseCalculationButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id else { return Effect.none }
        let featureState = AddQuickCalculationFeature.State(usageMode: .reuse(calculationId: id))
        state.destination = .addQuickCalculation(featureState)
        return .send(.hideTabbar)
    }

    func deleteCalculationButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id, let deletedCalculation = try? quickCalculationRepository.delete(where: id) else {
            return Effect.none
        }
        state.pinnedCalculations.remove(id: id)
        state.calculatedCalculations.remove(id: id)
        state.deletedCalculations.append(deletedCalculation)
        let calculation = deletedCalculation.toQuickCalculationDisplayModel
        return .send(.showToastMessage(QuickToastContext.deleted(calculation)))
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

    func showToastMessage(_ state: inout State, _ context: QuickToastContext) -> Effect<Action> {
        state.toastMessages.append(context)
        return Effect.run { send in
            try await Task.sleep(nanoseconds: Constants.toastAutoClearDelay)
            await send(.clearToastMessage(context))
        }
    }

    func clearToastMessage(_ state: inout State, _ context: QuickToastContext) -> Effect<Action> {
        state.toastMessages.remove(context)
        return Effect.none
    }

    func toastMessageActionButtonTapped(_ state: inout State, _ context: QuickToastContext) -> Effect<Action> {
        switch context {
        case let .deleted(calculation):
            guard let deletedCalculation = state.deletedCalculations.first(where: { $0.id == calculation.id }) else { break }
            try? quickCalculationRepository.save(deletedCalculation)
            state.deletedCalculations = state.deletedCalculations.filter { $0.id != calculation.id }
            return Effect.merge(
                .send(.loadPinnedCalculations),
                .send(.loadCalculatedCalculations),
                .send(.clearToastMessage(context))
            )
        default: break
        }
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
