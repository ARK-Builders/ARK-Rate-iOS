import SwiftUI

struct Storybook: PreviewProvider {

    static var previews: some View {
        ScrollView {
            Text("CurrencyRowView")
            CurrencyRowView(code: "USD", name: "Vietnamese Dong", rate: "1.00")
            CurrencyRowView(code: "VND", name: "United States Dollar", rate: "25515.16")
            CurrencyRowView(code: "KRW", rate: "1446.19")

            LineDivider()

            Text("PrimaryButton")
            PrimaryButton(title: "Calculate", icon: Image(systemName: "plus")) {}
            PrimaryButton(title: "Calculate") {}

            LineDivider()

            Text("SecondaryButton")
            SecondaryButton(title: "New Currency", icon: Image(systemName: "plus")) {}
            SecondaryButton(title: "New Currency") {}

            LineDivider()

            Text("CurrencyInputView")
            CurrencyInputView(label: "From", name: "USD", amount: .constant(""), placeHolder: "Input Value", action: {})
                .padding(.horizontal, 16)
            CurrencyInputView(label: "To", name: "USD", amount: .constant(""), placeHolder: "Input Value", action: {}, deleteButtonAction: {})
                .padding(.horizontal, 16)
            CurrencyInputView(name: "USD", amount: .constant(""), placeHolder: "Input Value", action: {}, deleteButtonAction: {})
                .padding(.horizontal, 16)

            LineDivider()

            Text("GroupMenuView")
            GroupMenuView(groups: .constant([]), addGroupAction: {})
                .padding(.horizontal, 16)
            GroupMenuView(groups: .constant([
                "Group 1",
                "Group 2",
                "Group 3"
            ]), addGroupAction: {})
                .padding(.horizontal, 16)
        }
    }
}
