import ComposableArchitecture

@Reducer
struct SettingsFeature {

    @ObservableState
    struct State: Equatable {}

    enum Action {
        case hideTabbar
        case showTabbar
    }
}
