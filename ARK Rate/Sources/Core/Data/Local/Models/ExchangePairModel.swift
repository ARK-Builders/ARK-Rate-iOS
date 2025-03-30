import Foundation
import SwiftData

@Model
final class ExchangePairModel {

    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var inputCurrencyCode: String
    var inputCurrencyAmount: Decimal
    var outputCurrenciesCode: Set<String>

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrenciesCode: Set<String>
    ) {
        self.id = id
        self.inputCurrencyCode = inputCurrencyCode
        self.inputCurrencyAmount = inputCurrencyAmount
        self.outputCurrenciesCode = outputCurrenciesCode
    }
}
