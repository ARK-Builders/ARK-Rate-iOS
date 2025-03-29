import Foundation
import ComposableArchitecture

@Reducer
struct AddNewCalculationFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var fromCurrency = AddingCurrencyDisplayModel(code: Constants.defaultFromCurrencyCode)
        var toCurrencies: IdentifiedArrayOf<AddingCurrencyDisplayModel> = []
        var currencies: [Currency] = []
        var selectionMode: SelectionMode?

        enum SelectionMode: Equatable {
            case fromCurrency
            case addingToCurrency
            case toCurrency(id: UUID)
        }
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case loadCurrencies
        case selectFromCurrency
        case updateFromCurrencyAmount(String)
        case selectToCurrency(UUID)
        case updateToCurrencyAmount(String, UUID)
        case addNewCurrencyButtonTapped
        case deleteCurrencyButtonTapped(UUID)
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
            case .selectToCurrency(let id): selectToCurrency(&state, id)
            case .updateToCurrencyAmount(let amount, let id): updateToCurrencyAmount(&state, amount, id)
            case .addNewCurrencyButtonTapped: addNewCurrencyButtonTapped(&state)
            case .deleteCurrencyButtonTapped(let id): deleteCurrencyButtonTapped(&state, id)
            case let .destination(.presented(.searchACurrency(.currencyCodeSelected(code)))): currencyCodeSelected(&state, code)
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

    func selectFromCurrency(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .fromCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateFromCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.fromCurrency.amount = amount
        return Effect.none
    }

    func selectToCurrency(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.selectionMode = .toCurrency(id: id)
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func updateToCurrencyAmount(_ state: inout State, _ amount: String, _ id: UUID) -> Effect<Action> {
        if let index = state.toCurrencies.index(id: id) {
            state.toCurrencies[index].amount = amount
        }
        return Effect.none
    }

    func addNewCurrencyButtonTapped(_ state: inout State) -> Effect<Action> {
        state.selectionMode = .addingToCurrency
        state.destination = .searchACurrency(SearchACurrencyFeature.State())
        return Effect.none
    }

    func deleteCurrencyButtonTapped(_ state: inout State, _ id: UUID) -> Effect<Action> {
        state.toCurrencies.remove(id: id)
        return Effect.none
    }

    func currencyCodeSelected(_ state: inout State, _ code: String) -> Effect<Action> {
        if let selectionMode = state.selectionMode {
            switch selectionMode {
            case .fromCurrency:
                state.fromCurrency.code = code
            case .addingToCurrency:
                state.toCurrencies.append(AddingCurrencyDisplayModel(code: code))
            case .toCurrency(let id):
                if let index = state.toCurrencies.index(id: id) {
                    state.toCurrencies[index].code = code
                }
            }
            state.selectionMode = nil
        }
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
