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
            }
            .listStyle(.plain)
            addButton
        }
    }

    var calculationsSection: some View {
        makeListSection(title: StringResource.calculations.localized) {
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

// MARK: - Helpers

private extension QuickView {

    func makeListSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        Section(header: Text(title)
            .foregroundColor(Color.textTertiary)
            .font(Font.customInterMedium(size: 14))
        ) {
            content()
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
