import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var selectedTabIndex: UInt = 0
        var tabbarIsHidden: Bool = false
        var quickState = QuickFeature.State()
        var settingsState = SettingsFeature.State()
    }

    enum Action {
        case tabIndexChanged(UInt)
        case tabbarIsHiddenToggled(Bool)
        case quickAction(QuickFeature.Action)
        case settingsAction(SettingsFeature.Action)
    }

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Scope(state: \.quickState, action: \.quickAction) {
            QuickFeature()
        }
        Scope(state: \.settingsState, action: \.settingsAction) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case .tabIndexChanged(let tabIndex): return tabIndexChanged(&state, tabIndex)
            case .tabbarIsHiddenToggled(let isHidden): return tabbarIsHiddenToggled(&state, isHidden)
            case .quickAction(.hideTabbar): return tabbarIsHiddenToggled(&state, true)
            case .quickAction(.showTabbar): return tabbarIsHiddenToggled(&state, false)
            default: return Effect.none
            }
        }
    }
}

// MARK: - Implementation

private extension AppFeature {

    func tabIndexChanged(_ state: inout State, _ tabIndex: UInt) -> Effect<Action> {
        state.selectedTabIndex = tabIndex
        return Effect.none
    }

    func tabbarIsHiddenToggled(_ state: inout State, _ isHidden: Bool) -> Effect<Action> {
        state.tabbarIsHidden = isHidden
        return Effect.none
    }
}
