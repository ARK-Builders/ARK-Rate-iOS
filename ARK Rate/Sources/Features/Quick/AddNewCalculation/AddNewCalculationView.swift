import SwiftUI
import ComposableArchitecture

struct AddNewCalculationView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<AddNewCalculationFeature>

    // MARK: - Body

    var body: some View {
        ScrollView {
            content
        }
        .modifier(
            NavigationBarModifier(
                title: StringResource.title.localized,
                backButtonAction: { store.send(.backButtonTapped) }
            )
        )
    }
}

// MARK: -

private extension AddNewCalculationView {

    var content: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            CurrencyInputView(
                label: StringResource.from.localized,
                name: store.fromCurrency.code,
                amount: $store.fromCurrency.amount.sending(\.updateFromCurrencyAmount),
                placeHolder: StringResource.inputValue.localized,
                action: {}
            )
            addingCurrenciesView
            SecondaryButton(
                title: StringResource.newCurrency.localized,
                icon: Image.plus,
                action: { store.send(.addNewCurrencyButtonTapped) }
            )
            GroupMenuView(
                groups: .constant([]),
                addGroupAction: {}
            )
        }
        .padding(Constants.spacing)
    }

    var addingCurrenciesView: some View {
        ForEach(store.toCurriences.indices, id: \.self) { index in
            CurrencyInputView(
                label: index == 0 ? StringResource.to.localized : nil,
                name: store.toCurriences[index].code,
                amount: Binding(
                    get: { store.toCurriences[index].amount },
                    set: { newValue in store.send(.updateToCurrencyAmount(index: index, amount: newValue)) }
                ),
                placeHolder: StringResource.inputValue.localized,
                action: {},
                deleteButtonAction: {}
            )
        }
    }
}

// MARK: - Constants

private extension AddNewCalculationView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case title = "add_new_calculation"
        case back
        case from
        case to
        case inputValue = "input_value"
        case newCurrency = "new_currency"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
