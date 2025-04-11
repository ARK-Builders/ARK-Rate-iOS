// MARK: -

extension QuickCalculation {

    var toQuickCalculationDTO: QuickCalculationDTO {
        QuickCalculationDTO(
            id: id,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }

    var toCodes: [String] {
        ([inputCurrencyCode] + outputCurrenciesCode)
    }

    var toCurrencyStatistics: [CurrencyStatistic] {
        toCodes.map { CurrencyStatistic(code: $0) }
    }
}

// MARK: -

extension QuickCalculationDTO {

    var toQuickCalculation: QuickCalculation {
        QuickCalculation(
            id: id,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }

    var toQuickCalculationModel: QuickCalculationModel {
        QuickCalculationModel(
            id: id,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}

// MARK: -

extension QuickCalculationModel {

    var toQuickCalculationDTO: QuickCalculationDTO {
        QuickCalculationDTO(
            id: id,
            calculatedDate: calculatedDate,
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}
