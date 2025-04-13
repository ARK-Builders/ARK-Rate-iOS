extension QuickCalculation {

    var toQuickCalculationDisplayModel: QuickCalculationDisplayModel {
        QuickCalculationDisplayModel(
            id: id,
            pinnedDate: pinnedDate,
            calculatedDate: calculatedDate,
            input: CurrencyDisplayModel(
                code: inputCurrencyCode,
                amount: inputCurrencyAmount
            ),
            outputs: zip(outputCurrencyCodes, outputCurrencyAmounts).map { code, amount in
                CurrencyDisplayModel(
                    code: code,
                    amount: amount
                )
            }
        )
    }
}
