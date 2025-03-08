import SwiftUI

struct CurrencyRowView: View {

    // MARK: - Properties

    let currencyName: String
    let currencyRate: String

    // MARK: - Body

    var body: some View {
        HStack {
            Text(currencyName)
                .font(.headline)
            Spacer()
            Text(currencyRate)
                .font(.subheadline)
        }
        .padding()
    }
}
