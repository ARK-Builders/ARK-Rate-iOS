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
                store.send(.loadListContent)
            }
        }
    }
}

// MARK: -

private extension QuickView {

    @ViewBuilder
    var content: some View {
        if !store.calculatedCalculations.isEmpty || !store.pinnedCalculations.isEmpty {
            list
        } else {
            emptyStateView
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
                pinnedPairsSection
                calculatedCalculationsSection
                frequentCurrenciesSection
                allCurrenciesSection
            }
            .listStyle(.plain)
            addButton
        }
    }

    @ViewBuilder
    var pinnedPairsSection: some View {
        if !store.pinnedCalculations.isEmpty {
            ListSection(title: StringResource.pinnedPairs.localized) {
                ForEach(store.pinnedCalculations, id: \.id) { calculation in
                    CurrencyCalculationRowView(
                        input: calculation.input,
                        outputs: calculation.outputs,
                        elapsedTime: StringResource.lastRefreshedAgo.localizedFormat(calculation.elapsedTime),
                        action: {}
                    )
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        makeTogglePinnedButton(for: calculation, action: {
                            store.send(.togglePinnedButtonTapped(id: calculation.id))
                        })
                    }
                    .modifier(PlainListRowModifier())
                }
            }
        }
    }

    @ViewBuilder
    var calculatedCalculationsSection: some View {
        if !store.calculatedCalculations.isEmpty {
            ListSection(title: StringResource.calculations.localized) {
                ForEach(store.calculatedCalculations, id: \.id) { calculation in
                    CurrencyCalculationRowView(
                        input: calculation.input,
                        outputs: calculation.outputs,
                        elapsedTime: StringResource.calculatedOnAgo.localizedFormat(calculation.elapsedTime),
                        action: {}
                    )
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        makeTogglePinnedButton(for: calculation, action: {
                            store.send(.togglePinnedButtonTapped(id: calculation.id))
                        })
                    }
                    .modifier(PlainListRowModifier())
                }
            }
        }
    }

    @ViewBuilder
    var frequentCurrenciesSection: some View {
        if !store.frequentCurrencies.isEmpty {
            ListSection(title: StringResource.frequentCurrencies.localized) {
                ForEach(store.frequentCurrencies, id: \.id) { currency in
                    CurrencyRowView(
                        code: currency.id,
                        name: currency.name,
                        action: {}
                    )
                    .modifier(PlainListRowModifier())
                }
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

// MARK: - Helpers

private extension QuickView {

    func makeTogglePinnedButton(
        for calculation: QuickCalculationDisplayModel,
        action: @escaping ButtonAction
    ) -> some View {
        Button(
            action: action,
            label: {
                Text(calculation.togglePinnedTitle)
                    .foregroundColor(Color.white)
                    .padding(Constants.spacing)
            }
        )
        .tint(Color.teal600)
    }
}

// MARK: - Constants

private extension QuickView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "quick_title"
        case pinnedPairs = "pinned_pairs"
        case calculations
        case lastRefreshedAgo = "last_refreshed_ago"
        case calculatedOnAgo = "calculated_on_ago"
        case allCurrencies = "all_currencies"
        case frequentCurrencies = "frequent_currencies"

        var localized: String {
            String(localized: rawValue)
        }

        func localizedFormat(_ args: CVarArg...) -> String {
            let format = String(localized: rawValue)
            return String(format: format, arguments: args)
        }
    }
}
