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
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group?.toQuickCalculationGroupDTO
        )
    }

    var toCurrencyStatistics: [CurrencyStatistic] {
        ([inputCurrencyCode] + outputCurrencyCodes).map { CurrencyStatistic(code: $0) }
    }

    func toQuickCalculation(
        calculatedDate: Date,
        outputCurrencyAmounts: [Decimal]
    ) -> QuickCalculation {
        QuickCalculation(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group
        )
    }

    func toQuickCalculation(pinnedDate: Date?) -> QuickCalculation {
        QuickCalculation(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrencyCodes: outputCurrencyCodes,
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group
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
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group?.toQuickCalculationGroup
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
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group?.toQuickCalculationGroupModel
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
            outputCurrencyAmounts: outputCurrencyAmounts,
            group: group?.toQuickCalculationGroupDTO
        )
    }
}
