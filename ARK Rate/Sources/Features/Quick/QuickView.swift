import SwiftUI
import SwiftUIX
import ComposableArchitecture

struct QuickView: View {

    // MARK: - Properties

    @State var isSearchBarEditing = false
    @State var isShowingCalculationOptions = false
    @Bindable var store: StoreOf<QuickFeature>

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                content
                toastView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundPrimary)
            .animation(.easeInOut, value: store.toastMessages)
            .sheet(isPresented: $isShowingCalculationOptions) {
                calculationOptionsBottomSheet
            }
            .navigationDestination(
                item: $store.scope(state: \.destination?.addQuickCalculation, action: \.destination.addQuickCalculation)
            ) { store in
                AddQuickCalculationView(store: store)
            }
            .onAppearOnce {
                store.send(.loadListContent)
            }
            .onAppear {
                store.send(.showTabbar)
            }
            .onDisappear {
                if store.destination != nil {
                    store.send(.hideTabbar)
                }
            }
        }
    }
}

// MARK: -

private extension QuickView {

    @ViewBuilder
    var content: some View {
        if !store.calculatedCalculations.isEmpty || !store.pinnedCalculations.isEmpty {
            VStack(spacing: 0) {
                searchBar
                contentListView
            }
        } else {
            emptyStateView
        }
    }

    var searchBar: some View {
        SearchBar(
            StringResource.search.localized,
            text: $store.searchText.sending(\.searchTextUpdated),
            isEditing: $isSearchBarEditing
        )
        .showsCancelButton(isSearchBarEditing)
        .textFieldBackgroundColor(Color.backgroundPrimary)
        .padding(.horizontal, Constants.spacing)
    }

    var contentListView: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                if !store.isSearching {
                    pinnedPairsSection
                    calculatedCalculationsSection
                    frequentCurrenciesSection
                    allCurrenciesSection
                } else {
                    searchingCurrenciesSection
                }
            }
            .listStyle(.plain)
            if store.isSearching && store.displayingCurrencies.isEmpty {
                CurrencyEmptyStateView()
            }
            addButton
        }
    }

    @ViewBuilder
    var pinnedPairsSection: some View {
        if !store.pinnedCalculations.isEmpty {
            ListSection(title: StringResource.pinnedCalculations.localized) {
                ForEach(store.pinnedCalculations, id: \.id) { calculation in
                    CurrencyCalculationRowView(
                        input: calculation.input,
                        outputs: calculation.outputs,
                        elapsedTime: StringResource.lastRefreshedAgo.localizedFormat(calculation.elapsedTime),
                        action: { calculationItemAction(calculation) }
                    )
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        makeTogglePinnedButton(for: calculation, action: {
                            store.send(.togglePinnedButtonTapped(id: calculation.id))
                        })
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        makeDeleteButton {
                            store.send(.deleteCalculationButtonTapped(id: calculation.id))
                        }
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
                        action: { calculationItemAction(calculation) }
                    )
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        makeTogglePinnedButton(
                            for: calculation,
                            action: {
                                store.send(.togglePinnedButtonTapped(id: calculation.id))
                            }
                        )
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        makeDeleteButton {
                            store.send(.deleteCalculationButtonTapped(id: calculation.id))
                        }
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
                        action: { store.send(.currencyCodeSelected(currency.id)) }
                    )
                    .modifier(PlainListRowModifier())
                }
            }
        }
    }

    var allCurrenciesSection: some View {
        ListSection(title: StringResource.allCurrencies.localized) {
            ForEach(store.allCurrencies, id: \.id) { currency in
                CurrencyRowView(
                    code: currency.id,
                    name: currency.name,
                    action: { store.send(.currencyCodeSelected(currency.id)) }
                )
                .modifier(PlainListRowModifier())
            }
        }
    }

    @ViewBuilder
    var searchingCurrenciesSection: some View {
        if !store.displayingCurrencies.isEmpty {
            ListSection(title: StringResource.topResults.localized) {
                ForEach(store.displayingCurrencies, id: \.id) { currency in
                    CurrencyRowView(
                        code: currency.id,
                        name: currency.name,
                        action: { store.send(.currencyCodeSelected(currency.id)) }
                    )
                    .modifier(PlainListRowModifier())
                }
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

    @ViewBuilder
    var toastView: some View {
        if let toastMessage = store.toastMessages.last {
            ToastView(
                icon: toastMessage.icon,
                title: toastMessage.content.title,
                subtitle: toastMessage.content.subtitle,
                closeButtonAction: {
                    store.send(.clearToastMessage(toastMessage))
                },
                actionButtonConfiguration: toastMessage.actionButtonTitle.map {
                    ButtonConfiguration(
                        title: $0,
                        action: { store.send(.toastMessageActionButtonTapped(toastMessage)) }
                    )
                }
            )
            .padding(Constants.spacing)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .identity
                )
            )
        }
    }

    var emptyStateView: some View {
        CalculationEmptyStateView {
            store.send(.addNewCalculationButtonTapped)
        }
    }

    var calculationOptionsBottomSheet: some View {
        func closeAction() {
            isShowingCalculationOptions = false
            store.send(.calculationItemSelected(nil))
        }
        return CalculationOptionsView(
            togglePinnedButtonTitle: store.selectedCalculation?.togglePinnedTitle,
            togglePinnedButtonAction: {
                store.send(.togglePinnedButtonTapped(id: store.selectedCalculation?.id))
                closeAction()
            },
            editButtonAction: {
                store.send(.editCalculationButtonTapped(id: store.selectedCalculation?.id))
                closeAction()
            },
            reuseButtonAction: {
                store.send(.reuseCalculationButtonTapped(id: store.selectedCalculation?.id))
                closeAction()
            },
            deleteButtonAction: {
                store.send(.deleteCalculationButtonTapped(id: store.selectedCalculation?.id))
                closeAction()
            },
            closeButtonAction: closeAction
        )
        .presentationCornerRadius(20)
        .presentationDetents([.fraction(hasExtendedTopArea ? 0.4 : 0.5)])
    }
}

// MARK: - Helpers

private extension QuickView {

    func calculationItemAction(_ calculation: QuickCalculationDisplayModel) {
        isShowingCalculationOptions = true
        store.send(.calculationItemSelected(calculation))
    }

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

    func makeDeleteButton(action: @escaping ButtonAction) -> some View {
        Button(
            action: action,
            label: {
                Text(StringResource.delete.localized)
                    .foregroundColor(Color.white)
                    .padding(Constants.spacing)
            }
        )
        .tint(Color.error)
    }
}

// MARK: - Constants

private extension QuickView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "quick_title"
        case search
        case pinnedCalculations = "pinned_calculations"
        case calculations
        case lastRefreshedAgo = "last_refreshed_ago"
        case calculatedOnAgo = "calculated_on_ago"
        case allCurrencies = "all_currencies"
        case frequentCurrencies = "frequent_currencies"
        case topResults = "top_results"
        case delete

        var localized: String {
            String(localized: rawValue)
        }

        func localizedFormat(_ args: CVarArg...) -> String {
            let format = String(localized: rawValue)
            return String(format: format, arguments: args)
        }
    }
}
