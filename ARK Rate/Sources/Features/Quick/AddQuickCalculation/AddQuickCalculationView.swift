import SwiftUI
import ComposableArchitecture

struct AddQuickCalculationView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<AddQuickCalculationFeature>

    // MARK: - Body

    var body: some View {
        ScrollView {
            content
        }
        .safeAreaInset(edge: .bottom) {
            footer
        }
        .background(Color.backgroundPrimary)
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
        .modifier(HideKeyboardModifier())
        .navigationDestination(
            item: $store.scope(state: \.destination?.searchACurrency, action: \.destination.searchACurrency)
        ) { store in
            SearchACurrencyView(store: store)
        }
        .onAppear {
            store.send(.loadCurrencies)
        }
    }
}

// MARK: -

private extension AddQuickCalculationView {

    var content: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            inputCurrencyView
            LineDivider()
            outputCurrenciesView
            SecondaryButton(
                title: StringResource.newCurrency.localized,
                icon: Image.plus,
                action: { store.send(.addOutputCurrencyButtonTapped) }
            )
            GroupMenuView(
                groups: .constant([]),
                addGroupAction: {}
            )
        }
        .padding(Constants.spacing)
    }

    var inputCurrencyView: some View {
        CurrencyInputView(
            label: StringResource.from.localized,
            name: store.inputCurrency.code,
            amount: $store.inputCurrency.amount.sending(\.updateInputCurrencyAmount),
            placeHolder: StringResource.inputValue.localized,
            action: { store.send(.selectInputCurrency) }
        )
    }

    var outputCurrenciesView: some View {
        ForEach(store.outputCurrencies) { currency in
            let isFirstItem = currency.id == store.outputCurrencies.first?.id
            CurrencyInputView(
                label: isFirstItem ? StringResource.to.localized : nil,
                name: currency.code,
                amount: Binding(
                    get: { currency.amount },
                    set: { newValue in store.send(.updateOutputCurrencyAmount(newValue, currency.id)) }
                ),
                placeHolder: StringResource.result.localized,
                isEditingEnabled: false,
                action: { store.send(.selectOutputCurrency(currency.id)) },
                deleteButtonAction: { store.send(.deleteOutputCurrencyButtonTapped(currency.id)) }
            )
        }
    }

    var footer: some View {
        VStack {
            PrimaryButton(
                title: StringResource.save.localized,
                disabled: store.quickCalculation == nil,
                expandHorizontally: true,
                action: { store.send(.saveButtonTapped) }
            )
            .padding(Constants.spacing)
        }
        .background(Color.backgroundPrimary)
    }
}

// MARK: - Constants

private extension AddQuickCalculationView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "add_new_calculation"
        case back
        case from
        case to
        case inputValue = "input_value"
        case result
        case newCurrency = "new_currency"
        case save

        var localized: String {
            String(localized: rawValue)
        }
    }
}
