// MARK: -

extension ExchangePair {

    var toExchangePairDTO: ExchangePairDTO {
        ExchangePairDTO(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}

// MARK: -

extension ExchangePairDTO {

    var toExchangePair: ExchangePair {
        ExchangePair(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }

    var toExchangePairModel: ExchangePairModel {
        ExchangePairModel(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}

// MARK: -

extension ExchangePairModel {

    var toExchangePairDTO: ExchangePairDTO {
        ExchangePairDTO(
            inputCurrencyCode: inputCurrencyCode,
            inputCurrencyAmount: inputCurrencyAmount,
            outputCurrenciesCode: outputCurrenciesCode
        )
    }
}
