import Foundation
import ComposableArchitecture

@Reducer
struct AddQuickCalculationFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var canSave: Bool = false
        var selectionMode: SelectionMode?
        var inputCurrency = AddingCurrencyDisplayModel(code: Constants.defaultInputCurrencyCode)
        var outputCurrencies: IdentifiedArrayOf<AddingCurrencyDisplayModel> = []

        enum SelectionMode: Equatable {
            case inputCurrency
            case addingOutputCurrency
            case outputCurrency(id: UUID)
        }
    }

    enum Action {
        case selectInputCurrency
        case updateInputCurrencyAmount(String)
        case selectOutputCurrency(UUID)
        case updateOutputCurrencyAmount(String, UUID)
        case addOutputCurrencyButtonTapped
        case deleteOutputCurrencyButtonTapped(UUID)
        case saveButtonTapped
        case backButtonTapped
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)

        enum Delegate: Equatable {
            case back
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.quickCalculationRepository) var quickCalculationRepository
    @Dependency(\.currencyStatisticRepository) var currencyStatisticRepository
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .selectInputCurrency: selectInputCurrency(&state)
            case .updateInputCurrencyAmount(let amount): updateInputCurrencyAmount(&state, amount)
            case .selectOutputCurrency(let id): selectOutputCurrency(&state, id)
            case .updateOutputCurrencyAmount(let amount, let id): updateOutputCurrencyAmount(&state, amount, id)
            case .addOutputCurrencyButtonTapped: addOutputCurrencyButtonTapped(&state)
            case .deleteOutputCurrencyButtonTapped(let id): deleteOutputCurrencyButtonTapped(&state, id)
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

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }

    func selectInputCurrency(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .inputCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateInputCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.inputCurrency.amount = Decimal.from(amount)
        updateCanSave(&state)
        updateOutputCurrencyAmounts(&state)
        return Effect.none
    }

    func selectOutputCurrency(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.selectionMode = .outputCurrency(id: id)
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateOutputCurrencyAmount(_ state: inout State, _ amount: String, _ id: UUID) -> Effect<Action> {
        if let index = state.outputCurrencies.index(id: id) {
            state.outputCurrencies[index].amount = Decimal.from(amount)
        }
        return Effect.none
    }

    func addOutputCurrencyButtonTapped(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .addingOutputCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
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
        updateCanSave(&state)
        updateOutputCurrencyAmounts(&state)
        return Effect.none
    }

    func saveButtonTapped(_ state: inout State) -> Effect<Action> {
        guard state.canSave else { return Effect.none }
        let quickCalculation = QuickCalculation(
            inputCurrencyCode: state.inputCurrency.code,
            inputCurrencyAmount: state.inputCurrency.amount,
            outputCurrencyCodes: state.outputCurrencies.map(\.code),
            outputCurrencyAmounts: state.outputCurrencies.map(\.amount)
        )
        let currencyStatistics = quickCalculation.toCurrencyStatistics
        try? quickCalculationRepository.save(quickCalculation)
        try? currencyStatisticRepository.save(currencyStatistics)
        return Effect.run { send in
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
        state.canSave = state.inputCurrency.isValid && state.outputCurrencies.allSatisfy { $0.isValid }
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
