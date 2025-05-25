import Foundation
import ComposableArchitecture

@Reducer
struct AddQuickCalculationFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var canSave: Bool = false
        var usageMode: UsageMode
        var selectionMode: SelectionMode?
        var selectedCalculationGroup: GroupDisplayModel?
        var addingCalculationGroupName: String = String.empty
        var calculationGroups: IdentifiedArrayOf<GroupDisplayModel> = []
        var inputCurrency = AddingCurrencyDisplayModel(code: Constants.defaultInputCurrencyCode)
        var outputCurrencies: IdentifiedArrayOf<AddingCurrencyDisplayModel> = []

        var codes: Set<String> {
            Set([inputCurrency.code] + outputCurrencies.map(\.code))
        }

        init(usageMode: UsageMode = .add(code: Constants.defaultInputCurrencyCode)) {
            self.usageMode = usageMode
        }

        enum UsageMode: Equatable {
            case add(code: String)
            case edit(calculationId: UUID)
            case reuse(calculationId: UUID)
        }

        enum SelectionMode: Equatable {
            case inputCurrency
            case addingOutputCurrency
            case outputCurrency(id: UUID)
        }
    }

    enum Action {
        case loadInitialData
        case selectInputCurrency
        case updateInputCurrencyAmount(String)
        case selectOutputCurrency(UUID)
        case addOutputCurrencyButtonTapped
        case deleteOutputCurrencyButtonTapped(UUID)
        case loadCalculationGroups
        case createCalculationGroup
        case updateAddingCalculationGroupName(String)
        case onSelectedCalculationGroup(GroupDisplayModel)
        case saveButtonTapped
        case backButtonTapped
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)

        enum Delegate: Equatable {
            case back
            case added(QuickCalculation)
            case edited(QuickCalculation)
            case reused(QuickCalculation)
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.quickCalculationRepository) var quickCalculationRepository
    @Dependency(\.quickCalculationGroupRepository) var quickCalculationGroupRepository
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase
    @Dependency(\.saveQuickCalculationUseCase) var saveQuickCalculationUseCase
    @Dependency(\.loadQuickCalculationGroupsUseCase) var loadQuickCalculationGroupsUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .loadInitialData: loadInitialData(&state)
            case .selectInputCurrency: selectInputCurrency(&state)
            case .updateInputCurrencyAmount(let amount): updateInputCurrencyAmount(&state, amount)
            case .selectOutputCurrency(let id): selectOutputCurrency(&state, id)
            case .addOutputCurrencyButtonTapped: addOutputCurrencyButtonTapped(&state)
            case .deleteOutputCurrencyButtonTapped(let id): deleteOutputCurrencyButtonTapped(&state, id)
            case .loadCalculationGroups: loadCalculationGroups(&state)
            case .createCalculationGroup: createCalculationGroup(&state)
            case .updateAddingCalculationGroupName(let groupName): updateAddingCalculationGroupName(&state, groupName)
            case .onSelectedCalculationGroup(let group): onSelectedCalculationGroup(&state, group)
            case .saveButtonTapped: saveButtonTapped(&state)
            case .backButtonTapped: backButtonTapped()
            case let .destination(.presented(.searchACurrency(.delegate(.currencyCodeDidSelect(code))))): currencyCodeDidSelect(&state, code)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension AddQuickCalculationFeature {

    func loadInitialData(_ state: inout State) -> Effect<Action> {
        switch state.usageMode {
        case .add(let code):
            state.inputCurrency = AddingCurrencyDisplayModel(code: code)
            state.selectedCalculationGroup = try? quickCalculationGroupRepository
                .get(where: QuickCalculationGroup.defaultGroupName)?
                .toGroupDisplayModel
        case .edit(let id), .reuse(let id):
            guard let calculation = try? quickCalculationRepository.get(where: id) else { break }
            state.inputCurrency = AddingCurrencyDisplayModel(
                code: calculation.inputCurrencyCode,
                amount: calculation.inputCurrencyAmount
            )
            let outputCurrencies = calculation.outputCurrencyCodes.map { AddingCurrencyDisplayModel(code: $0) }
            state.outputCurrencies = IdentifiedArrayOf(uniqueElements: outputCurrencies)
            updateOutputCurrencyAmounts(&state)
            updateCanSave(&state)
            state.selectedCalculationGroup = calculation.group.toGroupDisplayModel
        }
        state.calculationGroups = IdentifiedArrayOf(uniqueElements: getCalculationGroups())
        return Effect.none
    }

    func selectInputCurrency(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .inputCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State(disabledCodes: state.codes))
        return Effect.none
    }

    func updateInputCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.inputCurrency.amount = Decimal.from(amount)
        updateOutputCurrencyAmounts(&state)
        updateCanSave(&state)
        return Effect.none
    }

    func selectOutputCurrency(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.selectionMode = .outputCurrency(id: id)
        state.destination = .searchACurrency(SearchACurrencyFeature.State(disabledCodes: state.codes))
        return Effect.none
    }

    func addOutputCurrencyButtonTapped(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .addingOutputCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State(disabledCodes: state.codes))
        return Effect.none
    }

    func deleteOutputCurrencyButtonTapped(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.outputCurrencies.remove(id: id)
        updateCanSave(&state)
        return Effect.none
    }

    func currencyCodeDidSelect(_ state: inout State, _ code: String) -> Effect<Action> {
        if let selectionMode = state.selectionMode {
            switch selectionMode {
            case .inputCurrency:
                state.inputCurrency.code = code
            case .addingOutputCurrency:
                state.outputCurrencies.append(AddingCurrencyDisplayModel(code: code))
            case .outputCurrency(let id):
                if let index = state.outputCurrencies.index(id: id) {
                    state.outputCurrencies[index].code = code
                }
            }
            state.selectionMode = nil
        }
        updateOutputCurrencyAmounts(&state)
        updateCanSave(&state)
        return Effect.none
    }

    func loadCalculationGroups(_ state: inout State) -> Effect<Action> {
        state.calculationGroups = IdentifiedArrayOf(uniqueElements: getCalculationGroups())
        return Effect.none
    }

    func createCalculationGroup(_ state: inout State) -> Effect<Action> {
        guard !state.addingCalculationGroupName.isTrimmedEmpty else { return Effect.none }
        let group = QuickCalculationGroup(name: state.addingCalculationGroupName)
        try? quickCalculationGroupRepository.save(group)
        return Effect.merge(
            .send(.loadCalculationGroups),
            .send(.updateAddingCalculationGroupName(String.empty)),
            .send(.onSelectedCalculationGroup(group.toGroupDisplayModel)),
        )
    }

    func updateAddingCalculationGroupName(_ state: inout State, _ groupName: String) -> Effect<Action> {
        state.addingCalculationGroupName = groupName
        return Effect.none
    }

    func onSelectedCalculationGroup(_ state: inout State, _ group: GroupDisplayModel) -> Effect<Action> {
        state.selectedCalculationGroup = group
        updateCanSave(&state)
        return Effect.none
    }

    func saveButtonTapped(_ state: inout State) -> Effect<Action> {
        guard state.canSave, let groupId = state.selectedCalculationGroup?.id else { return Effect.none }
        var calculationId: UUID?
        if case .edit(let id) = state.usageMode {
            calculationId = id
        }
        guard let quickCalculation = saveQuickCalculationUseCase.execute(
            id: calculationId,
            inputCurrencyCode: state.inputCurrency.code,
            inputCurrencyAmount: state.inputCurrency.amount,
            outputCurrencyCodes: state.outputCurrencies.map(\.code),
            outputCurrencyAmounts: state.outputCurrencies.map(\.amount),
            groupId: groupId
        ) else {
            return .send(.backButtonTapped)
        }
        let action: Action
        switch state.usageMode {
        case .add: action = .delegate(.added(quickCalculation))
        case .edit: action = .delegate(.edited(quickCalculation))
        case .reuse: action = .delegate(.reused(quickCalculation))
        }
        return Effect.run { send in
            await send(action)
            await back()
        }
    }

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }
}

// MARK: - Helpers

private extension AddQuickCalculationFeature {

    func updateOutputCurrencyAmounts(_ state: inout State) {
        for (index, outputCurrency) in state.outputCurrencies.enumerated() {
            state.outputCurrencies[index].amount = currencyCalculationUseCase.execute(
                inputCurrencyCode: state.inputCurrency.code,
                inputCurrencyAmount: state.inputCurrency.amount,
                outputCurrencyCode: outputCurrency.code
            )
        }
    }

    func updateCanSave(_ state: inout State) {
        state.canSave = state.selectedCalculationGroup != nil &&
        state.inputCurrency.isValid &&
        !state.outputCurrencies.isEmpty &&
        state.outputCurrencies.allSatisfy { $0.isValid }
    }

    func getCalculationGroups() -> [GroupDisplayModel] {
        loadQuickCalculationGroupsUseCase.execute()
            .map(\.toGroupDisplayModel)
    }
}

// MARK: -

extension AddQuickCalculationFeature {

    @Reducer
    enum Destination {
        case searchACurrency(SearchACurrencyFeature)
    }
}

// MARK: -

extension AddQuickCalculationFeature.Destination.State: Equatable {}

// MARK: - Constants

private extension AddQuickCalculationFeature {

    enum Constants {
        static let defaultInputCurrencyCode = "USD"
    }
}
