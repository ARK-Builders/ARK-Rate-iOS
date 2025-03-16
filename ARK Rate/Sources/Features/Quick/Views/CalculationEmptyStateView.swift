import SwiftUI

struct CalculationEmptyStateView: View {

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Image("coins-swap")
                .padding(.bottom, 16)
            Text(StringResource.title.localized)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 20))
                .padding(.bottom, 8)
            Text(StringResource.subtitle.localized)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterSemiBold(size: 14))
                .padding(.bottom, 24)
            PrimaryButton(
                title: StringResource.calculate.localized,
                icon: Image.plus,
                action: {}
            )
        }
        .padding(.horizontal, 8)
    }
}

// MARK: -

private extension CalculationEmptyStateView {

    enum StringResource: String.LocalizationValue {
        case title = "ready_for_calculation"
        case subtitle = "ready_for_calculation_description"
        case calculate = "calculate"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
