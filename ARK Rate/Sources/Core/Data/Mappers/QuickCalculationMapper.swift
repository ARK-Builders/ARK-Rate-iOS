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
