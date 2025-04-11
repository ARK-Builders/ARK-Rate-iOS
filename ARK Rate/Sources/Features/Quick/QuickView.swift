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
        ZStack(alignment: .bottomTrailing) {
            List {
                calculationsSection
                allCurrenciesSection
            }
            .listStyle(.plain)
            addButton
        }
    }

    var calculationsSection: some View {
        ListSection(title: StringResource.calculations.localized) {
            ForEach(store.quickCalculations, id: \.id) { calculation in
                CurrencyCalculationRowView(
                    input: calculation.input,
                    outputs: calculation.outputs,
                    elapsedTime: StringResource.calculatedOnAgo.localizedFormat(calculation.elapsedTime),
                    action: {}
                )
                .modifier(PlainListRowModifier())
            }
        }
    }

    var allCurrenciesSection: some View {
        ListSection(title: StringResource.allCurrencies.localized) {
            ForEach(store.displayingCurrencies, id: \.id) { currency in
                CurrencyRowView(
                    code: currency.id,
                    name: currency.name,
                    action: {}
                )
                .modifier(PlainListRowModifier())
            }
        }
    }

    var addButton: some View {
        Button(
            action: { store.send(.addNewCalculationButtonTapped) },
            label: {
                Image.plus
                    .foregroundColor(Color.white)
                    .font(Font.customInterBold(size: 24))
                    .frame(width: 56, height: 56)
                    .modifier(CircleBorderModifier(color: Color.teal700, backgroundColor: Color.teal600))
                    .padding(16)
            }
        )
    }
}

// MARK: - Constants

private extension QuickView {

    enum StringResource: String.LocalizationValue {
        case title = "quick_title"
        case calculations
        case calculatedOnAgo = "calculated_on_ago"
        case allCurrencies = "all_currencies"

        var localized: String {
            String(localized: rawValue)
        }

        func localizedFormat(_ args: CVarArg...) -> String {
            let format = String(localized: rawValue)
            return String(format: format, arguments: args)
        }
    }
}
