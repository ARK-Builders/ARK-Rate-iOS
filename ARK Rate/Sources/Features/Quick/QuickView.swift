import SwiftUI
import ComposableArchitecture

struct QuickView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<QuickFeature>

    // MARK: - Body

    var body: some View {
        NavigationStack {
            VStack {
                CalculationEmptyStateView() {
                    store.send(.addNewCalculationButtonTapped)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationDestination(
                item: $store.scope(state: \.destination?.addNewCalculation, action: \.destination.addNewCalculation)
            ) { store in
                AddNewCalculationView(store: store)
            }
        }
    }
}

// MARK: - Constants

private extension QuickView {

    enum StringResource: String.LocalizationValue {
        case title = "quick_title"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
