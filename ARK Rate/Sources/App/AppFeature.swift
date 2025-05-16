import ComposableArchitecture

@Reducer
struct AppFeature {

    @ObservableState
    struct State: Equatable {
        var selectedTabIndex: UInt = 0
        var tabbarIsHidden: Bool = false
        var currenciesState = CurrenciesFeature.State()
        var quickState = QuickFeature.State()
        var settingsState = SettingsFeature.State()
    }

    enum Action {
        case didFinishLaunching
        case tabIndexChanged(UInt)
        case tabbarIsHiddenToggled(Bool)
        case currenciesAction(CurrenciesFeature.Action)
        case quickAction(QuickFeature.Action)
        case settingsAction(SettingsFeature.Action)
    }

    // MARK: - Properties

    @Dependency(\.metadataRepository) var metadataRepository

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Scope(state: \.currenciesState, action: \.currenciesAction) {
            CurrenciesFeature()
        }
        Scope(state: \.quickState, action: \.quickAction) {
            QuickFeature()
        }
        Scope(state: \.settingsState, action: \.settingsAction) {
            SettingsFeature()
        }
        Reduce { state, action in
            switch action {
            case .didFinishLaunching: return didFinishLaunching(&state)
            case .tabIndexChanged(let tabIndex): return tabIndexChanged(&state, tabIndex)
            case .tabbarIsHiddenToggled(let isHidden): return tabbarIsHiddenToggled(&state, isHidden)
            case .currenciesAction(.currenciesUpdated(let currencies)): return .send(.quickAction(.currenciesUpdated(currencies)))
            case .quickAction(.hideTabbar), .settingsAction(.hideTabbar): return tabbarIsHiddenToggled(&state, true)
            case .quickAction(.showTabbar), .settingsAction(.showTabbar): return tabbarIsHiddenToggled(&state, false)
            default: return Effect.none
            }
        }
    }
}

// MARK: - Implementation

private extension AppFeature {

    func didFinishLaunching(_ state: inout State) -> Effect<Action> {
        var effects: [Effect<Action>] = [.send(.currenciesAction(.fetchCurrencies))]
        if !metadataRepository.hasLaunchedBefore() {
            metadataRepository.recordHasLaunchedBefore()
            effects.append(.send(.quickAction(.addDefaultQuickCalculationGroup)))
        }
        return Effect.merge(effects)
    }

    func tabIndexChanged(_ state: inout State, _ tabIndex: UInt) -> Effect<Action> {
        state.selectedTabIndex = tabIndex
        return Effect.none
    }

    func tabbarIsHiddenToggled(_ state: inout State, _ isHidden: Bool) -> Effect<Action> {
        state.tabbarIsHidden = isHidden
        return Effect.none
    }
}
