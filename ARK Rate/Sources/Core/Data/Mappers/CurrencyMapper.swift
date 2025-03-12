// MARK: -

extension CurrencyDTO {

    var toCurrency: Currency {
        let category: Currency.Category
        switch self.category {
        case .fiat: category = Currency.Category.fiat
        case .crypto: category = Currency.Category.crypto
        }
        return Currency(
            code: code,
            rate: rate,
            category: category
        )
    }

    var toCurrencyModel: CurrencyModel {
        CurrencyModel(
            code: code,
            rate: rate,
            categoryRaw: category.rawValue
        )
    }
}

// MARK: -

extension FiatCurrenciesRateResponse {

    var toCurrencyDTOs: [CurrencyDTO] {
        rates.map {
            CurrencyDTO(
                code: $0.key,
                rate: $0.value,
                category: CurrencyDTO.Category.fiat
            )
        }
    }
}

// MARK: -

extension CryptoCurrencyRateResponse {

    var toCurrencyDTO: CurrencyDTO {
        CurrencyDTO(
            code: symbol,
            rate: currentPrice,
            category: CurrencyDTO.Category.crypto
        )
    }
}

// MARK: -

extension CurrencyModel {

    var toCurrencyDTO: CurrencyDTO {
        CurrencyDTO(
            code: code,
            rate: rate,
            category: CurrencyDTO.Category(rawValue: categoryRaw)!
        )
    }
}
