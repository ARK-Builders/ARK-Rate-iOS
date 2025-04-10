// MARK: -

extension CurrencyStatistic {

    var toCurrencyStatisticDTO: CurrencyStatisticDTO {
        CurrencyStatisticDTO(
            code: code,
            usageCount: usageCount,
            lastUsedDate: lastUsedDate
        )
    }
}

// MARK: -

extension CurrencyStatisticDTO {

    var toCurrencyStatistic: CurrencyStatistic {
        CurrencyStatistic(
            code: code,
            usageCount: usageCount,
            lastUsedDate: lastUsedDate
        )
    }

    var toCurrencyStatisticModel: CurrencyStatisticModel {
        CurrencyStatisticModel(
            code: code,
            usageCount: usageCount,
            lastUsedDate: lastUsedDate
        )
    }
}

// MARK: -

extension CurrencyStatisticModel {

    var toCurrencyStatisticDTO: CurrencyStatisticDTO {
        CurrencyStatisticDTO(
            code: code,
            usageCount: usageCount,
            lastUsedDate: lastUsedDate
        )
    }
}
