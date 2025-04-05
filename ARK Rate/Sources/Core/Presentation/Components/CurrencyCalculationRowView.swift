import SwiftUI

struct CurrencyCalculationRowView: View {

    enum BadgeStyle: Equatable {
        case pair(from: String, to: String)
        case group(from: String, plus: Int)
    }

    // MARK: - Properties

    let title: String
    let subtitle: String
    let details: String?
    let refreshTime: String
    let badgeStyle: BadgeStyle
    let action: ButtonAction

    @State private var isExpanded: Bool = false

    // MARK: - Initialization

    init(
        title: String,
        subtitle: String,
        details: String? = nil,
        refreshTime: String,
        badgeStyle: BadgeStyle,
        action: @escaping ButtonAction
    ) {
        self.title = title
        self.subtitle = subtitle
        self.details = details
        self.refreshTime = refreshTime
        self.badgeStyle = badgeStyle
        self.action = action
    }

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                LineDivider()
                HStack(spacing: 12) {
                    badge
                    content
                    Spacer()
                    if details != nil {
                        Button(action: { isExpanded.toggle() }) {
                            (isExpanded ? Image.chevronUp : Image.chevronDown)
                                .foregroundColor(Color.grayNeutral)
                        }
                    }
                }
                .padding(.vertical, Constants.verticalSpacing)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.horizontal, Constants.horizontalSpacing)
        .background(Color.backgroundPrimary)
    }
}

// MARK: -

private extension CurrencyCalculationRowView {

    var badge: some View {
        ZStack(alignment: .leading) {
            switch badgeStyle {
            case .pair(let from, let to):
                makeBadgeImage(code: from)
                makeBadgeImage(code: to)
                    .offset(x: Constants.badgeImageOffset)
            case .group(let from, let plus):
                makeBadgeImage(code: from)
                Text("\(plus)+")
                    .font(Font.customInterSemiBold(size: 16))
                    .frame(width: Constants.badgeImageSize, height: Constants.badgeImageSize)
                    .modifier(CircleBorderModifier())
                    .offset(x: Constants.badgeImageOffset)
            }
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundColor(Color.textPrimary)
                .font(Font.customInterMedium(size: 14))
            Text(subtitle)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterRegular(size: 14))
            Text(refreshTime)
                .foregroundColor(Color.textTertiary)
                .font(Font.customInterRegular(size: 12))
        }
    }

    func makeBadgeImage(code: String) -> some View {
        Image.image(code)
            .resizable()
            .frame(width: Constants.badgeImageSize, height: Constants.badgeImageSize)
            .modifier(CircleBorderModifier())
    }
}

// MARK: - Constants

private extension CurrencyCalculationRowView {

    enum Constants {
        static let verticalSpacing: CGFloat = 16
        static let horizontalSpacing: CGFloat = 24
        static let badgeImageSize: CGFloat = 40
        static let badgeImageOffset: CGFloat = 0
    }
}
