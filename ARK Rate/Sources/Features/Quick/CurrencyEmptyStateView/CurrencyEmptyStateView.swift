import SwiftUI

struct CurrencyEmptyStateView: View {

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Image(ImageResource.search)
                .padding(.bottom, Constants.spacing)
            Text(StringResource.noResult.localized)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterSemiBold(size: 20))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: -

private extension CurrencyEmptyStateView {

    enum Constants {
        static let spacing: CGFloat = 16
    }

    enum StringResource: String.LocalizationValue {
        case noResult = "no_result"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
