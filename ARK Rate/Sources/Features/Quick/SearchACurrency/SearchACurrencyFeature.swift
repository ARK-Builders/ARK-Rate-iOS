import ComposableArchitecture

@Reducer
struct SearchACurrencyFeature {

    @ObservableState
    struct State: Equatable {
        var curriences: [CurrencyDisplayModel] = []
    }

    enum Action {
        case backButtonTapped
        case delegate(Delegate)

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
        default: Effect.none
        }
    }
}

// MARK: - Implementation

private extension SearchACurrencyFeature {

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }
}
