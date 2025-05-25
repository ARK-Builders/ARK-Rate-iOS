import SwiftUI
import SwiftUIX
import ComposableArchitecture
import UniformTypeIdentifiers

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
            .onAppear {
                store.send(.showTabbar)
                store.send(.loadListContent)
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
        if store.hasContent {
            VStack(spacing: 0) {
                searchBar
                if !store.isSearching && store.calculationGroups.count > 1 {
                    calculationGroups
                }
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

    var calculationGroups: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(store.calculationGroups.indices, id: \.self) { index in
                    let isSelected = index == store.selectedGroupIndex
                    makeCalculationGroupItem(
                        isSelected: isSelected,
                        group: store.calculationGroups[index],
                        action: { store.send(.selectGroupIndex(index)) }
                    )
                }
            }
        }
        .padding(.top, Constants.spacing)
    }

    var contentListView: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(
                selection: Binding(
                    get: { store.selectedGroupIndex },
                    set: { newValue in store.send(.selectGroupIndex(newValue)) }
                )
            ) {
                ForEach(store.calculationGroups.indices, id: \.self) { index in
                    List {
                        if !store.isSearching {
                            makePinnedPairsSection(store.pinnedCalculations[index])
                            makeCalculatedCalculationsSection(store.calculatedCalculations[index])
                            frequentCurrenciesSection
                            allCurrenciesSection
                        } else {
                            searchingCurrenciesSection
                        }
                    }
                    .listStyle(.plain)
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: store.selectedGroupIndex)
            if store.isSearching && store.displayingCurrencies.isEmpty {
                CurrencyEmptyStateView()
            }
            addButton
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

    func makeCalculationGroupItem(
        isSelected: Bool,
        group: GroupDisplayModel,
        action: @escaping ButtonAction
    ) -> some View {
        Button(
            action: action,
            label: {
                VStack(spacing: 12) {
                    Text(group.displayName)
                        .foregroundColor(Color.teal600)
                        .font(Font.customInterSemiBold(size: 16))
                        .padding(.horizontal, 26)
                    VStack(spacing: 0) {
                        if isSelected {
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color.teal600)
                        }
                        LineDivider()
                    }
                }
            }
        )
    }

    @ViewBuilder
    func makePinnedPairsSection(_ calculations: IdentifiedArrayOf<QuickCalculationDisplayModel>) -> some View {
        if !calculations.isEmpty {
            ListSection(title: StringResource.pinnedCalculations.localized) {
                ForEach(calculations, id: \.id) { calculation in
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
    func makeCalculatedCalculationsSection(_ calculations: IdentifiedArrayOf<QuickCalculationDisplayModel>) -> some View {
        if !calculations.isEmpty {
            ListSection(title: StringResource.calculations.localized) {
                ForEach(calculations, id: \.id) { calculation in
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
