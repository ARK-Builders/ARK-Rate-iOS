import SwiftUI
import SwiftUIX

struct CurrencyInputView: View {

    // MARK: - Properties

    let label: String
    @Binding var name: String
    @Binding var amount: String
    let placeHolder: String
    let action: ButtonAction
    let deleteButtonAction: ButtonAction?

    // MARK: - Initialization

    init(
        label: String,
        name: Binding<String>,
        amount: Binding<String>,
        placeHolder: String,
        action: @escaping ButtonAction,
        deleteButtonAction: ButtonAction? = nil
    ) {
        self.label = label
        self._name = name
        self._amount = amount
        self.placeHolder = placeHolder
        self.action = action
        self.deleteButtonAction = deleteButtonAction
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .foregroundColor(Color.textSecondary)
                .font(Font.customInterMedium(size: 14))
            HStack(spacing: 16) {
                textField
                deleteButton
            }
        }
    }
}

// MARK: -

private extension CurrencyInputView {

    var textField: some View {
        HStack(spacing: 12) {
            Button(action: action) {
                HStack(spacing: 4) {
                    Text(name)
                        .foregroundColor(Color.textSecondary)
                        .font(Font.customInterRegular(size: 16))
                    Image.chevronDown
                        .foregroundColor(Color.grayNeutral)
                }
            }
            .padding(.leading, Constants.horizontalSpacing)
            TextField(placeHolder, text: $amount)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterRegular(size: 16))
                .padding(.vertical, Constants.verticalSpacing)
                .padding(.trailing, Constants.horizontalSpacing)
        }
        .modifier(RoundedBorderModifier())
    }

    @ViewBuilder
    var deleteButton: some View {
        if let deleteButtonAction {
            Button(action: deleteButtonAction) {
                Image(ImageResource.trash)
                    .padding(.vertical, Constants.verticalSpacing)
                    .padding(.horizontal, 16)
            }
            .frame(maxHeight: .infinity)
            .modifier(RoundedBorderModifier(color: Color.error))
        } else {
            EmptyView()
        }
    }
}

// MARK: - Constants

private extension CurrencyInputView {

    enum Constants {
        static let verticalSpacing: CGFloat = 10
        static let horizontalSpacing: CGFloat = 14
    }
}
