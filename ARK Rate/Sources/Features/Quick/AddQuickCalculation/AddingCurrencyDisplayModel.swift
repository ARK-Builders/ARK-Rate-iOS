import Foundation

struct AddingCurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id = UUID()
    var code: String
    var amount: Decimal

    var displayingAmount: String {
        amount > 0 ? "\(amount.formattedRate)" : String.empty
    }

    var isValid: Bool {
        !code.isEmpty && amount > 0
    }

    // MARK: - Initialization

    init(code: String = String.empty,
         amount: Decimal = 0
    ) {
        self.code = code
        self.amount = amount
    }
}
