import Foundation

// MARK: -

extension Currency {

    var toCurrencyDTO: CurrencyDTO {
        let category: CurrencyDTO.Category
        switch self.category {
        case .fiat: category = .fiat
        case .crypto: category = .crypto
        }
        return CurrencyDTO(
            code: code,
            rate: rate,
            category: category
        )
    }
}

// MARK: -

extension CurrencyDTO {

    var toCurrency: Currency {
        let category: Currency.Category
        switch self.category {
        case .fiat: category = .fiat
        case .crypto: category = .crypto
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
                code: $0.key.uppercased(),
                rate: Decimal(1).divideArk($0.value),
                category: CurrencyDTO.Category.fiat
            )
        }
    }
}

// MARK: -

extension CryptoCurrencyRateResponse {

    var toCurrencyDTO: CurrencyDTO {
        CurrencyDTO(
            code: symbol.uppercased(),
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
