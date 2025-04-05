import SwiftUI

struct Storybook: PreviewProvider {

    static var previews: some View {
        ScrollView {
            VStack {
                Text("CurrencyRowView")
                CurrencyRowView(code: "USD", name: "United States Dollar")
                CurrencyRowView(code: "KRW")

                LineDivider()

                Text("PrimaryButton")
                PrimaryButton(title: "Calculate", icon: Image(systemName: "plus")) {}
                PrimaryButton(title: "Calculate") {}
                PrimaryButton(title: "Calculate", expandHorizontally: true) {}
                    .padding(.horizontal, Constants.spacing)

                LineDivider()

                Text("SecondaryButton")
                SecondaryButton(title: "New Currency", icon: Image(systemName: "plus")) {}
                SecondaryButton(title: "New Currency") {}
                SecondaryButton(title: "New Currency", expandHorizontally: true) {}
                    .padding(.horizontal, Constants.spacing)

                LineDivider()

                Text("CurrencyInputView")
                CurrencyInputView(
                    label: "From",
                    name: "USD",
                    amount: .constant(""),
                    placeHolder: "Input Value",
                    action: {}
                )
                    .padding(.horizontal, Constants.spacing)
                CurrencyInputView(
                    label: "To",
                    name: "USD",
                    amount: .constant(""),
                    placeHolder: "Input Value",
                    action: {},
                    deleteButtonAction: {}
                )
                    .padding(.horizontal, Constants.spacing)

                LineDivider()

                Text("GroupMenuView")
                GroupMenuView(groups: .constant([]), addGroupAction: {})
                    .padding(.horizontal, Constants.spacing)
                GroupMenuView(groups: .constant([
                    "Group 1",
                    "Group 2",
                    "Group 3"
                ]), addGroupAction: {})
                .padding(.horizontal, Constants.spacing)
            }
            .padding(.bottom, Constants.spacing)
        }
    }
}

// MARK: - Constants

private extension Storybook {

    enum Constants {
        static let spacing: CGFloat = 16
    }
}
