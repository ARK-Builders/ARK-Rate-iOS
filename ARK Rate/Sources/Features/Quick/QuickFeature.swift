import ComposableArchitecture

@Reducer
struct QuickFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }

    enum Action {
        case addNewCalculationButtonTapped
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addNewCalculationButtonTapped: addNewCalculationButtonTapped(&state)
            case .destination(.presented(.addNewCalculation(.delegate(.back)))): .send(.showTabbar)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension QuickFeature {

    func addNewCalculationButtonTapped(_ state: inout State) -> Effect<Action> {
        state.destination = .addNewCalculation(AddNewCalculationFeature.State())
        return .send(.hideTabbar)
    }
}

// MARK: -

extension QuickFeature {

    @Reducer
    enum Destination {
        case addNewCalculation(AddNewCalculationFeature)
    }
}

// MARK: -

extension QuickFeature.Destination.State: Equatable {}
