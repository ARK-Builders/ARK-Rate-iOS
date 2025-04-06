import SwiftUI
import ComposableArchitecture

struct QuickView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<QuickFeature>

    // MARK: - Body

    var body: some View {
        NavigationStack {
            content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .navigationDestination(
                item: $store.scope(state: \.destination?.addQuickCalculation, action: \.destination.addQuickCalculation)
            ) { store in
                AddQuickCalculationView(store: store)
            }
            .onAppear {
                store.send(.loadCurrencies)
            }
        }
    }
}

// MARK: -

private extension QuickView {

    @ViewBuilder
    var content: some View {
        if store.quickCalculations.isEmpty {
            emptyStateView
        } else {
            list
        }
    }

    var emptyStateView: some View {
        CalculationEmptyStateView {
            store.send(.addNewCalculationButtonTapped)
        }
    }

    var list: some View {
        List {
            calculationsSection
        }
        .listStyle(.plain)
    }

    var calculationsSection: some View {
        Section(header: Text(StringResource.calculations.localized)
            .foregroundColor(Color.textTertiary)
            .font(Font.customInterMedium(size: 14))
        ) {
            ForEach(store.quickCalculations, id: \.id) { calculation in
                CurrencyCalculationRowView(
                    input: calculation.input,
                    outputs: calculation.outputs,
                    elapsedTime: StringResource.calculatedOnAgo.localizedFormat(calculation.elapsedTime),
                    action: {}
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
            }
        }
    }
}

// MARK: - Constants

private extension QuickView {

    enum StringResource: String.LocalizationValue {
        case title = "quick_title"
        case calculations
        case calculatedOnAgo = "calculated_on_ago"

        var localized: String {
            String(localized: rawValue)
        }

        func localizedFormat(_ args: CVarArg...) -> String {
            let format = String(localized: rawValue)
            return String(format: format, arguments: args)
        }
    }
}
