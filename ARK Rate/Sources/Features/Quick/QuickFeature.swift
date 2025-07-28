import Foundation
import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var hasContent = false
        var searchText = String.empty
        var editingGroupName = String.empty
        var selectedGroupIndex = 0
        var selectedEditingGroup: GroupDisplayModel?
        var selectedCalculation: QuickCalculationDisplayModel?
        var calculationGroups: IdentifiedArrayOf<GroupDisplayModel> = []
        var pinnedCalculations: [IdentifiedArrayOf<QuickCalculationDisplayModel>] = []
        var calculatedCalculations: [IdentifiedArrayOf<QuickCalculationDisplayModel>] = []
        var allCurrencies: [CurrencyDisplayModel] = []
        var frequentCurrencies: [CurrencyDisplayModel] = []
        var displayingCurrencies: [CurrencyDisplayModel] = []

        var deletedCalculations: [QuickCalculation] = []
        var toastMessages: IdentifiedArrayOf<QuickToastContext> = []

        var isSearching: Bool {
            !searchText.isTrimmedEmpty
        }

        var selectedGroup: GroupDisplayModel? {
            calculationGroups[safe: selectedGroupIndex]
        }
    }

    enum Action {
        case addDefaultGroup
        case loadCurrencies
        case loadCalculations
        case loadListContent
        case selectGroup(GroupDisplayModel)
        case editingGroupNameUpdated(String)
        case renameGroupButtonTapped(id: UUID?)
        case deleteGroupButtonTapped(id: UUID?)
        case currenciesUpdated([Currency])
        case addNewCalculationButtonTapped
        case currencyCodeSelected(String)
        case togglePinnedButtonTapped(id: UUID?)
        case editCalculationButtonTapped(id: UUID?)
        case reuseCalculationButtonTapped(id: UUID?)
        case deleteCalculationButtonTapped(id: UUID?)
        case editingGroupSelected(GroupDisplayModel?)
        case calculationItemSelected(QuickCalculationDisplayModel?)
        case searchTextUpdated(String)
        case reorderGroup(GroupDisplayModel, GroupDisplayModel)
        case commitGroupsOrdering
        case showToastMessage(QuickToastContext)
        case clearToastMessage(QuickToastContext)
        case toastMessageActionButtonTapped(QuickToastContext)
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.quickCalculationRepository) var quickCalculationRepository
    @Dependency(\.quickCalculationGroupRepository) var quickCalculationGroupRepository
    @Dependency(\.loadQuickCalculationsUseCase) var loadQuickCalculationsUseCase
    @Dependency(\.loadQuickCalculationGroupsUseCase) var loadQuickCalculationGroupsUseCase
    @Dependency(\.loadCurrenciesUseCase) var loadCurrenciesUseCase
    @Dependency(\.loadFrequentCurrenciesUseCase) var loadFrequentCurrenciesUseCase
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase
    @Dependency(\.togglePinnedCalculationUseCase) var togglePinnedCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addDefaultGroup: addDefaultGroup(&state)
            case .loadCurrencies: loadCurrencies(&state)
            case .loadCalculations: loadCalculations(&state)
            case .loadListContent: loadListContent(&state)
            case .selectGroup(let group): selectGroup(&state, group)
            case .editingGroupNameUpdated(let groupName): editingGroupNameUpdated(&state, groupName)
            case .renameGroupButtonTapped(let id): renameGroupButtonTapped(&state, id)
            case .deleteGroupButtonTapped(let id): deleteGroupButtonTapped(&state, id)
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .currencyCodeSelected(let code): currencyCodeSelected(&state, code)
            case .togglePinnedButtonTapped(let id): togglePinnedButtonTapped(&state, id)
            case .editCalculationButtonTapped(let id): editCalculationButtonTapped(&state, id)
            case .reuseCalculationButtonTapped(let id): reuseCalculationButtonTapped(&state, id)
            case .deleteCalculationButtonTapped(let id): deleteCalculationButtonTapped(&state, id)
            case .editingGroupSelected(let group): editingGroupSelected(&state, group)
            case .calculationItemSelected(let calculation): calculationItemSelected(&state, calculation)
            case .searchTextUpdated(let searchText): searchTextUpdated(&state, searchText)
            case .reorderGroup(let source, let destination): reorderGroup(&state, source, destination)
            case .commitGroupsOrdering: commitGroupsOrdering(&state)
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

    func addDefaultGroup(_ state: inout State) -> Effect<Action> {
        let group = QuickCalculationGroup(
            name: QuickCalculationGroup.defaultGroupName,
            displayOrder: 0
        )
        try? quickCalculationGroupRepository.save(group)
        return Effect.none
    }

    func loadCalculations(_ state: inout State) -> Effect<Action> {
        let calculationGroups = loadQuickCalculationGroupsUseCase.execute()
        state.calculationGroups = IdentifiedArrayOf(uniqueElements: calculationGroups.map(\.toGroupDisplayModel))
        state.pinnedCalculations = loadQuickCalculationsUseCase.getPinnedCalculations(groupBy: calculationGroups)
            .map { IdentifiedArrayOf(uniqueElements: $0.map(\.toQuickCalculationDisplayModel)) }
        state.calculatedCalculations = loadQuickCalculationsUseCase.getCalculatedCalculations(groupBy: calculationGroups)
            .map { IdentifiedArrayOf(uniqueElements: $0.map(\.toQuickCalculationDisplayModel)) }
        state.hasContent = state.calculatedCalculations.contains(where: { !$0.isEmpty }) || state.pinnedCalculations.contains(where: { !$0.isEmpty })
        return Effect.none
    }

    func loadCurrencies(_ state: inout State) -> Effect<Action> {
        state.allCurrencies = loadCurrenciesUseCase.getLocal()
            .map(\.toCurrencyDisplayModel)
        state.frequentCurrencies = loadFrequentCurrenciesUseCase.execute()
            .map(\.toCurrencyDisplayModel)
        return Effect.none
    }

    func loadListContent(_ state: inout State) -> Effect<Action> {
        return Effect.merge(
            .send(.loadCurrencies),
            .send(.loadCalculations)
        )
    }

    func selectGroup(_ state: inout State, _ group: GroupDisplayModel) -> Effect<Action> {
        if let groupIndex = state.calculationGroups.index(id: group.id) {
            state.selectedGroupIndex = groupIndex
        }
        return Effect.none
    }

    func editingGroupNameUpdated(_ state: inout State, _ groupName: String) -> Effect<Action> {
        state.editingGroupName = groupName
        return Effect.none
    }

    func renameGroupButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id, let group = try? quickCalculationGroupRepository.get(where: id) else { return Effect.none }
        let editedGroup = group.toQuickCalculationGroup(name: state.editingGroupName)
        try? quickCalculationGroupRepository.save(editedGroup)
        return Effect.merge(
            .send(.loadListContent),
            .send(.editingGroupSelected(nil))
        )
    }

    func deleteGroupButtonTapped(_ state: inout State, _ id: UUID?) -> Effect<Action> {
        guard let id else { return Effect.none }
        try? quickCalculationGroupRepository.delete(where: id)
        return Effect.merge(
            .send(.loadListContent),
            .send(.editingGroupSelected(nil))
        )
    }

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addQuickCalculation(AddQuickCalculationFeature.State())
        return .send(.hideTabbar)
    }

    func onAddQuickCalculationCallback(_ state: inout State, _ delegate: AddQuickCalculationFeature.Action.Delegate) -> Effect<Action> {
        let group: GroupDisplayModel
        let calculation: QuickCalculationDisplayModel
        let toastMessage: QuickToastContext
        let isInitialCalculation = state.calculatedCalculations.isEmpty && state.pinnedCalculations.isEmpty
        switch delegate {
        case .added(let addedCalculation):
            group = addedCalculation.group.toGroupDisplayModel
            calculation = addedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.added(calculation)
        case .edited(let editedCalculation):
            group = editedCalculation.group.toGroupDisplayModel
            calculation = editedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.edited(calculation)
        case .reused(let reusedCalculation):
            group = reusedCalculation.group.toGroupDisplayModel
            calculation = reusedCalculation.toQuickCalculationDisplayModel
            toastMessage = QuickToastContext.reused(calculation)
        default: return Effect.none
        }
        let reloadEffect: Effect<Action> = isInitialCalculation ?
            .send(.loadListContent) :
            .send(.loadCalculations)
        return Effect.merge(
            reloadEffect,
            .send(.selectGroup(group)),
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
        return .send(.loadCalculations)
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
        state.deletedCalculations.append(deletedCalculation)
        let calculation = deletedCalculation.toQuickCalculationDisplayModel
        return Effect.merge(
            .send(.loadCalculations),
            .send(.showToastMessage(QuickToastContext.deleted(calculation)))
        )
    }

    func editingGroupSelected(_ state: inout State, _ group: GroupDisplayModel?) -> Effect<Action> {
        state.selectedEditingGroup = group
        return Effect.none
    }

    func calculationItemSelected(_ state: inout State, _ calculation: QuickCalculationDisplayModel?) -> Effect<Action> {
        state.selectedCalculation = calculation
        return Effect.none
    }

    func searchTextUpdated(_ state: inout State, _ searchText: String) -> Effect<Action> {
        state.searchText = searchText
        state.displayingCurrencies = state.isSearching ? state.allCurrencies.filter {
            $0.id.localizedCaseInsensitiveContains(searchText) ||
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.countries.contains { $0.localizedCaseInsensitiveContains(searchText) }
        } : []
        return Effect.none
    }

    func reorderGroup(_ state: inout State, _ source: GroupDisplayModel, _ destination: GroupDisplayModel) -> Effect<Action> {
        guard source != destination,
              let sourceIndex = state.calculationGroups.index(id: source.id),
              let destinationIndex = state.calculationGroups.index(id: destination.id) else {
            return Effect.none
        }
        let adjustedTargetIndex = destinationIndex > sourceIndex ? destinationIndex + 1 : destinationIndex
        state.calculationGroups.move(
            fromOffsets: IndexSet(integer: sourceIndex),
            toOffset: min(adjustedTargetIndex, state.calculationGroups.endIndex)
        )
        return Effect.none
    }

    func commitGroupsOrdering(_ state: inout State) -> Effect<Action> {
        let calculationGroups = loadQuickCalculationGroupsUseCase.execute()
        let indexMap = Dictionary(uniqueKeysWithValues: state.calculationGroups.enumerated().map { offset, group in (group.id, offset) })
        let editedGroups = calculationGroups.map { editedGroup in
            editedGroup.toQuickCalculationGroup(displayOrder: indexMap[editedGroup.id]!)
        }
        try? quickCalculationGroupRepository.save(editedGroups)
        return .send(.loadCalculations)
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
                .send(.loadCalculations),
                .send(.clearToastMessage(context))
            )
        default: break
        }
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

// MARK: - Constants

private extension QuickFeature {

    enum Constants {
        static let toastAppearDelay: UInt64 = 350_000_000
        static let toastAutoClearDelay: UInt64 = 10_000_000_000
    }
}
