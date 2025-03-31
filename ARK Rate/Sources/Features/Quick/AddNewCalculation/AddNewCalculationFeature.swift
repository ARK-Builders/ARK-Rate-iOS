import Foundation
import ComposableArchitecture

@Reducer
struct AddNewCalculationFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var quickCalculation: QuickCalculation?
        var inputCurrency = AddingCurrencyDisplayModel(code: Constants.defaultInputCurrencyCode)
        var outputCurrencies: IdentifiedArrayOf<AddingCurrencyDisplayModel> = []
        var currencies: [Currency] = []
        var selectionMode: SelectionMode?

        enum SelectionMode: Equatable {
            case inputCurrency
            case addingOutputCurrency
            case outputCurrency(id: UUID)
        }
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies
        case selectInputCurrency
        case updateInputCurrencyAmount(String)
        case selectOutputCurrency(UUID)
        case updateOutputCurrencyAmount(String, UUID)
        case addOutputCurrencyButtonTapped
        case deleteOutputCurrencyButtonTapped(UUID)
        case saveButtonTapped
        case destination(PresentationAction<Destination.Action>)

        enum Delegate: Equatable {
            case back
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back
    @Dependency(\.currencyRepository) var currencyRepository
    @Dependency(\.quickCalculationRepository) var quickCalculationRepository
    @Dependency(\.currencyCalculationUseCase) var currencyCalculationUseCase

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped: backButtonTapped()
            case .loadCurrencies: loadCurrencies(&state)
            case .selectInputCurrency: selectInputCurrency(&state)
            case .updateInputCurrencyAmount(let amount): updateInputCurrencyAmount(&state, amount)
            case .selectOutputCurrency(let id): selectOutputCurrency(&state, id)
            case .updateOutputCurrencyAmount(let amount, let id): updateOutputCurrencyAmount(&state, amount, id)
            case .addOutputCurrencyButtonTapped: addOutputCurrencyButtonTapped(&state)
            case .deleteOutputCurrencyButtonTapped(let id): deleteOutputCurrencyButtonTapped(&state, id)
            case .saveButtonTapped: saveButtonTapped(&state)
            case let .destination(.presented(.searchACurrency(.delegate(.currencyCodeDidSelect(code))))): currencyCodeDidSelect(&state, code)
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
            currencies = try currencyRepository.getLocal()
        } catch {}
        state.currencies = currencies
        return Effect.none
    }

    func selectInputCurrency(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .inputCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateInputCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.inputCurrency.amount = amount
        updateQuickCalculation(&state)
        updateOutputCurrenciesAmount(&state)
        return Effect.none
    }

    func selectOutputCurrency(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.selectionMode = .outputCurrency(id: id)
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateOutputCurrencyAmount(_ state: inout State, _ amount: String, _ id: UUID) -> Effect<Action> {
        if let index = state.outputCurrencies.index(id: id) {
            state.outputCurrencies[index].amount = amount
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
        updateQuickCalculation(&state)
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
        updateQuickCalculation(&state)
        updateOutputCurrenciesAmount(&state)
        return Effect.none
    }

    func saveButtonTapped(_ state: inout State) -> Effect<Action> {
        if let quickCalculation = state.quickCalculation {
            do {
                try quickCalculationRepository.save(quickCalculation)
            } catch {}
        }
        return Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }
}

// MARK: - Helpers

private extension AddNewCalculationFeature {

    func updateOutputCurrenciesAmount(_ state: inout State) {
        guard let inputCurrencyAmount = Decimal(string: state.inputCurrency.amount),
        let inputCurrency = state.currencies.first(where: { $0.code == state.inputCurrency.code }),
        !state.outputCurrencies.isEmpty else { return }
        let outputCurrencies = state.currencies.filter { currency in
            state.outputCurrencies.contains(where: { $0.code == currency.code })
        }
        guard !outputCurrencies.isEmpty else { return }
        let currencyAmounts = currencyCalculationUseCase.execute(
            inputCurrency: inputCurrency,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencies: outputCurrencies
        )
        for (index, currency) in state.outputCurrencies.enumerated() {
            state.outputCurrencies[index].amount = currencyAmounts[currency.code]?.formattedRate ?? ""
        }
    }

    func updateQuickCalculation(_ state: inout State) {
        state.quickCalculation = if let inputCurrencyAmount = Decimal(string: state.inputCurrency.amount), !state.outputCurrencies.isEmpty {
            QuickCalculation(
                inputCurrencyCode: state.inputCurrency.code,
                inputCurrencyAmount: inputCurrencyAmount,
                outputCurrenciesCode: state.outputCurrencies.map { $0.code }
            )
        } else {
            nil
        }
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
        static let defaultInputCurrencyCode = "USD"
    }
}
