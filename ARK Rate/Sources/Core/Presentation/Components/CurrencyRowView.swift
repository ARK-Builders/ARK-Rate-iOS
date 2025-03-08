import SwiftUI

struct CurrencyRowView: View {

    // MARK: - Properties

    let currency: CurrencyDisplayModel

    // MARK: - Body

    var body: some View {
        HStack {
            Text(currency.id)
                .font(.headline)
            Spacer()
            Text("\(currency.formattedRate)")
                .font(.subheadline)
        }
        .padding()
    }
}
