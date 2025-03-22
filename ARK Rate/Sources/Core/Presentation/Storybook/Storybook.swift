import SwiftUI

struct Storybook: PreviewProvider {

    static var previews: some View {
        ScrollView {
            Text("CurrencyRowView")
            CurrencyRowView(currencyName: "USD", currencyRate: "1.00")
            CurrencyRowView(currencyName: "VND", currencyRate: "25515.16")
            CurrencyRowView(currencyName: "KRW", currencyRate: "1446.19")

            Text("PrimaryButton")
            PrimaryButton(title: "Calculate", icon: Image(systemName: "plus")) {}
            PrimaryButton(title: "Calculate") {}

            Text("CurrencyInputView")
            CurrencyInputView(label: "From", name: .constant("USD"), amount: .constant(""), placeHolder: "Input Value", action: {})
                .padding(.horizontal, 16)
            CurrencyInputView(label: "To", name: .constant("USD"), amount: .constant(""), placeHolder: "Input Value", action: {}, deleteButtonAction: {})
                .padding(.horizontal, 16)

            Text("GroupMenuView")
            GroupMenuView(groups: .constant([]), addGroupAction: {})
                .padding(.horizontal, 16)
        }
    }
}
