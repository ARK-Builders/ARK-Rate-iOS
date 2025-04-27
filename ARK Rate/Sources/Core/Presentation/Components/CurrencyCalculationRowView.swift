import SwiftUI

struct CurrencyCalculationRowView: View {

    // MARK: - Properties

    let input: CurrencyDisplayModel
    let outputs: [CurrencyDisplayModel]
    let elapsedTime: String
    let action: ButtonAction

    @State private var isExpanded: Bool = false

    // MARK: - Initialization

    init?(
        input: CurrencyDisplayModel,
        outputs: [CurrencyDisplayModel],
        elapsedTime: String,
        action: @escaping ButtonAction
    ) {
        guard !outputs.isEmpty else { return nil }

        self.input = input
        self.outputs = outputs
        self.elapsedTime = elapsedTime
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                LineDivider()
                HStack(alignment: .top, spacing: 12) {
                    badge
                    content
                    Spacer()
                    toggleExpandButton
                }
                .padding(.vertical, Constants.verticalSpacing)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.horizontalSpacing)
        .background(Color.backgroundPrimary)
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

// MARK: -

private extension CurrencyCalculationRowView {

    var badge: some View {
        ZStack(alignment: .leading) {
            makeImage(code: input.id, size: Constants.badgeImageSize)
            additionalBadgeContent {
                if isGroup {
                    Text("+\(outputs.count - 1)")
                        .foregroundColor(Color.textTertiary600)
                        .font(Font.customInterSemiBold(size: 16))
                        .frame(width: Constants.badgeImageSize, height: Constants.badgeImageSize)
                        .modifier(
                            CircleBorderModifier(
                                width: 2,
                                color: Color.borderSecondary
                            )
                        )
                } else if let to = outputs.first {
                    makeImage(code: to.id, size: Constants.badgeImageSize)
                }
            }
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterMedium(size: 14))
            Text(subtitle)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterRegular(size: 14))
            if isExpanded {
                ForEach(outputs, id: \.id) { currency in
                    HStack(spacing: 8) {
                        makeImage(code: currency.id, size: Constants.currencyImageSize)
                        Text(currency.formattedAmount)
                            .foregroundColor(Color.textTertiary)
                            .font(Font.customInterRegular(size: 14))
                    }
                }
            }
            Text(elapsedTime)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterRegular(size: 12))
        }
    }

    @ViewBuilder
    var toggleExpandButton: some View {
        if isGroup {
            Button(
                action: {
                    withAnimation(nil) { isExpanded.toggle() }
                },
                label: {
                    (isExpanded ? Image.chevronUp : Image.chevronDown)
                        .foregroundColor(Color.grayNeutral)
                        .frame(width: Constants.buttonSize, height: Constants.buttonSize)
                        .contentShape(Rectangle())
                }
            )
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Helpers

private extension CurrencyCalculationRowView {

    var isGroup: Bool {
        outputs.count > 1
    }

    var title: String {
        let take = 2
        let ids = outputs.map(\.id)
        let prefixIds = ids.prefix(take).joined(separator: ", ")
        let remaining = outputs.count > take ? ", \(StringResource.and.localized) \(outputs.count - take)+" : String.empty
        return "\(input.id) \(StringResource.to.localized) \(prefixIds)\(remaining)"
    }

    var subtitle: String {
        let remaining = isExpanded ? String.empty : "\(outputs.first?.formattedAmount ?? String.empty)"
        return "\(input.formattedAmount) = \(remaining)"
    }

    func makeImage(code: String, size: CGFloat) -> some View {
        Image.image(code)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .modifier(CircleBorderModifier(
                color: Color.borderSecondary,
                backgroundColor: Constants.currencyBackgroundColor)
            )
    }

    @ViewBuilder
    func additionalBadgeContent<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        if !isExpanded {
            content()
                .offset(x: Constants.badgeImageOffset)
                .padding(.trailing, Constants.badgeImageOffset)
        }
    }
}

// MARK: - Constants

private extension CurrencyCalculationRowView {

    enum Constants {
        static let verticalSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 24
        static let buttonSize: CGFloat = 44
        static let badgeImageSize: CGFloat = 40
        static let badgeImageOffset: CGFloat = 28
        static let currencyImageSize: CGFloat = 20
        static let currencyBackgroundColor = Color.white
    }

    enum StringResource: String.LocalizationValue {
        case to
        case and

        var localized: String {
            String(localized: rawValue)
        }
    }
}
