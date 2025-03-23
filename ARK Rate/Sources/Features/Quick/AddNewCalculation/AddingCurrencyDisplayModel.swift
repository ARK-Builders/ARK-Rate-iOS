import Foundation

struct AddingCurrencyDisplayModel: Identifiable, Equatable {

    // MARK: - Properties

    let id = UUID()
    var code: String
    var amount: String

    // MARK: - Initialization

    init(code: String = "",
         amount: String = ""
    ) {
        self.code = code
        self.amount = amount
    }
}
