import Foundation

// MARK: -

extension QuickCalculation {

    var toQuickCalculationDTO: QuickCalculationDTO {
        QuickCalculationDTO(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts
        )
    }

    var toCurrencyStatistics: [CurrencyStatistic] {
        ([inputCurrencyCode] + outputCurrencyCodes).map { CurrencyStatistic(code: $0) }
    }

    func toQuickCalculation(with outputCurrencyAmounts: [Decimal]) -> QuickCalculation {
        QuickCalculation(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts
        )
    }
}

// MARK: -

extension QuickCalculationDTO {

    var toQuickCalculation: QuickCalculation {
        QuickCalculation(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts
        )
    }

    var toQuickCalculationModel: QuickCalculationModel {
        QuickCalculationModel(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts
        )
    }
}

// MARK: -

extension QuickCalculationModel {

    var toQuickCalculationDTO: QuickCalculationDTO {
        QuickCalculationDTO(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts
        )
    }
}
