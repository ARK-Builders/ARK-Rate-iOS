import SwiftUI

struct InputView: View {

    // MARK: - Properties

    let title: String
    let placeholder: String
    @Binding var input: String

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(Color.textSecondary)
                .font(Font.customInterMedium(size: 14))
            ZStack {
                TextField(placeholder, text: $input)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.textPrimary)
                    .font(Font.customInterRegular(size: 16))
                    .padding(.horizontal, 14)
            }
            .frame(height: 48)
            .modifier(RoundedBorderModifier())
        }
    }
}
