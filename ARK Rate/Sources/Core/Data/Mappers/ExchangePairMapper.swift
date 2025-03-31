// MARK: -

extension QuickCalculation {

    var toQuickCalculationDTO: QuickCalculationDTO {
        QuickCalculationDTO(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}

// MARK: -

extension QuickCalculationDTO {

    var toQuickCalculation: QuickCalculation {
        QuickCalculation(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }

    var toQuickCalculationModel: QuickCalculationModel {
        QuickCalculationModel(
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
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}
