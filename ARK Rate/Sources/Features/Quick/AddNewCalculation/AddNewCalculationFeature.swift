import ComposableArchitecture

@Reducer
struct AddNewCalculationFeature {

    @ObservableState
    struct State: Equatable {
        var fromCurrency = AddingCurrencyDisplayModel()
        var toCurriences: [AddingCurrencyDisplayModel] = [AddingCurrencyDisplayModel()]
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)
        case updateFromCurrencyAmount(amount: String)
        case updateToCurrencyAmount(index: Int, amount: String)
        case addNewCurrencyButtonTapped

        enum Delegate: Equatable {
            case back
        }
    }

    // MARK: - Properties

    @Dependency(\.dismiss) var back

    // MARK: - Reducer

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .backButtonTapped: backButtonTapped()
        case .updateFromCurrencyAmount(let amount): updateFromCurrencyAmount(&state, amount)
        case .updateToCurrencyAmount(let index, let amount): updateToCurrencyAmount(&state, amount, index)
        case .addNewCurrencyButtonTapped: addNewCurrencyButtonTapped(&state)
        default: Effect.none
        }
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

    func updateFromCurrencyAmount(_ state: inout State, _ amount: String) -> Effect<Action> {
        state.fromCurrency.amount = amount
        return Effect.none
    }

    func updateToCurrencyAmount(_ state: inout State, _ amount: String, _ index: Int) -> Effect<Action> {
        state.toCurriences[index].amount = amount
        return Effect.none
    }

    func addNewCurrencyButtonTapped(_ state: inout State) -> Effect<Action> {
        state.toCurriences.append(AddingCurrencyDisplayModel())
        return Effect.none
    }
}
