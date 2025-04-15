import SwiftUI

struct CalculationOptionsView: View {

    // MARK: - Properties

    let pinButtonAction: ButtonAction
    let editButtonAction: ButtonAction
    let reuseButtonAction: ButtonAction
    let deleteButtonAction: ButtonAction
    let closeButtonAction: ButtonAction

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            title
            options
            Spacer()
        }
        .background(Color.backgroundPrimary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: -

private extension CalculationOptionsView {

    var title: some View {
        HStack {
            Text(StringResource.options.localized)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 18))
            Spacer()
            Button(
                action: closeButtonAction,
                label: Image.close
                    .font(.system(size: 16))
                    .foregroundColor(Color.foregroundQuarterary)
            )
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
        .padding(.horizontal, Constants.spacing)
    }

    var options: some View {
        VStack(spacing: Constants.optionSpacing) {
            SecondaryButton(
                title: StringResource.pin.localized,
                icon: Image(.pin),
                expandHorizontally: true,
                action: pinButtonAction
            )
            SecondaryButton(
                title: StringResource.edit.localized,
                icon: Image(.edit),
                expandHorizontally: true,
                action: editButtonAction
            )
            SecondaryButton(
                title: StringResource.reuse.localized,
                icon: Image(.reuse),
                expandHorizontally: true,
                action: reuseButtonAction
            )
            ActionButton(
                title: StringResource.delete.localized,
                icon: Image(.trash),
                style: .custom(foregroundColor: Color.error, backgroundColor: Color.clear),
                expandHorizontally: true,
                action: editButtonAction
            )
            .modifier(RoundedBorderModifier(color: Color.error))
        }
        .padding(.bottom, Constants.optionSpacing)
        .padding(.horizontal, Constants.spacing)
    }
}

// MARK: -

private extension CalculationOptionsView {

    enum Constants {
        static let spacing: CGFloat = 16
        static let optionSpacing: CGFloat = 12
    }

    enum StringResource: String.LocalizationValue {
        case options
        case pin
        case edit
        case reuse
        case delete

        var localized: String {
            String(localized: rawValue)
        }
    }
}
