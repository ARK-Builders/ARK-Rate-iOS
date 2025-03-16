import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var selectedTabIndex = 0
        var quickState = QuickFeature.State()
        var settingsState = SettingsFeature.State()
    }

    enum Action {
        case tabIndexChanged(Int)
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
            case .tabIndexChanged(let tabIndex):
                state.selectedTabIndex = tabIndex
                return .none
            }
        }
    }
}
