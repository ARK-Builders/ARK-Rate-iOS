extension Currency {

    var toCurrencyDisplayModel: CurrencyDisplayModel {
        CurrencyDisplayModel(code: code)
    }

    func toCurrencyDisplayModel(disabled: Bool) -> CurrencyDisplayModel {
        CurrencyDisplayModel(
            code: code,
            disabled: disabled
        )
    }
}
