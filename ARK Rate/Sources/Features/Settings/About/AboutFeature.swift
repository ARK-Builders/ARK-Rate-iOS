import Foundation
import ComposableArchitecture

@Reducer
struct AboutFeature {

    @ObservableState
    struct State: Equatable {}

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

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .backButtonTapped: backButtonTapped()
            default: Effect.none
            }
        }
    }
}

// MARK: - Implementation

private extension AboutFeature {

    func backButtonTapped() -> Effect<Action> {
        Effect.run { send in
            await send(.delegate(.back))
            await back()
        }
    }
}
