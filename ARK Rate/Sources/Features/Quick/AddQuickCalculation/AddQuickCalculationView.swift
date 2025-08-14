import SwiftUI
import SwiftUIX
import ComposableArchitecture

struct AddQuickCalculationView: View {

    // MARK: - Properties

    @State var isShowingAddGroupModal = false
    @Bindable var store: StoreOf<AddQuickCalculationFeature>

    // MARK: - Body

    var body: some View {
        ZStack {
            content
            .safeAreaInset(edge: .bottom) {
                footer
            }
            addGroupModal
        }
        .background(Color.backgroundPrimary)
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                disabled: isShowingAddGroupModal,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
        .dismissKeyboardOnTap()
        .navigationDestination(
            item: $store.scope(state: \.destination?.searchACurrency, action: \.destination.searchACurrency)
        ) { store in
            SearchACurrencyView(store: store)
        }
        .onAppearOnce {
            store.send(.loadInitialData)
        }
    }
}

// MARK: -

private extension AddQuickCalculationView {

    var content: some View {
        PlainList {
            inputCurrencyView
            LineDivider()
                .listRowPlainStyle()
            outputCurrenciesView
            addNewCurrencyButton
            groupMenuView
        }
        .padding(Constants.spacing)
    }

    var inputCurrencyView: some View {
        CurrencyInputView(
            label: StringResource.from.localized,
            name: store.inputCurrency.code,
            amount: Binding(
                get: { store.inputCurrency.inputtingAmount },
                set: { newValue in store.send(.updateInputCurrencyAmount(newValue)) }
            ),
            placeHolder: StringResource.inputValue.localized,
            action: { store.send(.selectInputCurrency) }
        )
        .listRowPlainStyle()
    }

    var outputCurrenciesView: some View {
        ForEach(store.outputCurrencies) { currency in
            let isFirstItem = currency.id == store.outputCurrencies.first?.id
            CurrencyInputView(
                label: isFirstItem ? StringResource.to.localized.capitalized : nil,
                name: currency.code,
                amount: .constant(currency.formattedAmount),
                placeHolder: StringResource.result.localized,
                isEditingEnabled: false,
                action: { store.send(.selectOutputCurrency(currency.id)) },
                deleteButtonAction: { store.send(.deleteOutputCurrencyButtonTapped(currency.id)) }
            )
            .listRowPlainStyle()
            .padding(.bottom, Constants.spacing)
        }
    }

    var addNewCurrencyButton: some View {
        SecondaryButton(
            title: StringResource.newCurrency.localized,
            icon: Image.plus,
            action: { store.send(.addOutputCurrencyButtonTapped) }
        )
        .listRowPlainStyle()
        .padding(.bottom, Constants.spacing)
    }

    var groupMenuView: some View {
        GroupMenuView(
            groupName: .constant(store.selectedCalculationGroup?.displayName ?? StringResource.newGroup.localized),
            groups: store.calculationGroups.elements,
            addGroupAction: {
                isShowingAddGroupModal = true
            },
            onSelectedGroupAction: { group in
                store.send(.onSelectedCalculationGroup(group))
            }
        )
        .listRowPlainStyle()
    }

    var footer: some View {
        VStack {
            PrimaryButton(
                title: StringResource.save.localized,
                disabled: !store.canSave,
                expandHorizontally: true,
                action: { store.send(.saveButtonTapped) }
            )
            .padding(Constants.spacing)
        }
    }

    var addGroupModal: some View {
        func closeAction() {
            isShowingAddGroupModal = false
        }
        return Group {
            if isShowingAddGroupModal {
                Color.backgroundOverlay
                    .ignoresSafeArea()
                    .zIndex(Constants.modalBackgroundZIndex)
                AddGroupModal(
                    groupName: Binding(
                        get: { store.addingCalculationGroupName },
                        set: { newValue in store.send(.updateAddingCalculationGroupName(newValue)) }
                    ),
                    closeButtonAction: closeAction,
                    cancelButtonAction: closeAction,
                    confirmButtonAction: {
                        closeAction()
                        store.send(.createCalculationGroup)
                    }
                )
                .zIndex(Constants.modalZIndex)
            }
        }
    }
}

// MARK: - Constants

private extension AddQuickCalculationView {

    enum Constants {
        static let spacing: CGFloat = 16
        static let modalZIndex: Double = 2
        static let modalBackgroundZIndex: Double = 1
    }

    enum StringResource: String.LocalizationValue {
        case title = "add_new_calculation"
        case back
        case from
        case to
        case inputValue = "input_value"
        case result
        case newCurrency = "new_currency"
        case newGroup = "new_group"
        case save

        var localized: String {
            String(localized: rawValue)
        }
    }
}
