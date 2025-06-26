import SwiftUI
import ComposableArchitecture

@Reducer
struct SettingsFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var types: [SettingItemType] = SettingItemType.allCases
    }

    enum Action {
        case goToSettings
        case showAboutScreen
        case hideTabbar
        case showTabbar
        case destination(PresentationAction<Destination.Action>)
    }

    // MARK: - Properties

    @Dependency(\.openURL) var openURL

    // MARK: - Reducer

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .goToSettings: goToSettings()
            case .showAboutScreen: showAboutScreen(&state)
            default: Effect.none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

// MARK: - Implementation

private extension SettingsFeature {

    func goToSettings() -> Effect<Action> {
        Effect.run { _ in 
            await openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }

    func showAboutScreen(_ state: inout State) -> Effect<Action> {
        state.destination = .about(AboutFeature.State())
        return .send(.hideTabbar)
    }
}

// MARK: -

extension SettingsFeature {

    @Reducer
    enum Destination {
        case about(AboutFeature)
    }
}

// MARK: -

extension SettingsFeature.Destination.State: Equatable {}
