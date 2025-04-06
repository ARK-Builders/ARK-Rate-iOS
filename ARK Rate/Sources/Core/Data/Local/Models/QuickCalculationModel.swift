import Foundation
import SwiftData

@Model
final class QuickCalculationModel {

    // MARK: - Properties

    @Attribute(.unique) var id: UUID
    var calculatedDate: Date
    var inputCurrencyCode: String
    var inputCurrencyAmount: Decimal
    var outputCurrenciesCode: [String]

    // MARK: - Initialization

    init(
        id: UUID,
        calculatedDate: Date,
        inputCurrencyCode: String,
        inputCurrencyAmount: Decimal,
        outputCurrenciesCode: [String]
    ) {
        self.id = id
        self.calculatedDate = calculatedDate
        self.inputCurrencyCode = inputCurrencyCode
        self.inputCurrencyAmount = inputCurrencyAmount
        self.outputCurrenciesCode = outputCurrenciesCode
    }
}
