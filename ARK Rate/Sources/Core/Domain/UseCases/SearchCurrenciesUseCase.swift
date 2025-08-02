struct SearchCurrenciesUseCase {

    // MARK: - Methods

    func execute(
        query: String,
        allCurrencies: [CurrencyDisplayModel],
        frequentCurrencies: [CurrencyDisplayModel]
    ) -> [CurrencyDisplayModel] {
        let commonCurrencies = allCurrencies.filter { Constants.commonCodes.contains($0.id) }
        return allCurrencies
            .filter {
                $0.id.localizedCaseInsensitiveContains(query) ||
                $0.name.localizedCaseInsensitiveContains(query) ||
                $0.countries.contains { $0.localizedCaseInsensitiveContains(query) }
            }
            .sorted { lhs, rhs in
                let lhsIsCommon = commonCurrencies.contains(lhs)
                let rhsIsCommon = commonCurrencies.contains(rhs)
                guard lhsIsCommon == rhsIsCommon else {
                    return lhsIsCommon && !rhsIsCommon
                }

                let lhsIsExact = isExactMatch(of: lhs, to: query)
                let rhsIsExact = isExactMatch(of: rhs, to: query)
                guard lhsIsExact == rhsIsExact else {
                    return lhsIsExact && !rhsIsExact
                }

                let lhsPrefixLength = prefixMatchLength(of: lhs, with: query)
                let rhsPrefixLength = prefixMatchLength(of: rhs, with: query)
                guard lhsPrefixLength == rhsPrefixLength else {
                    return lhsPrefixLength > rhsPrefixLength
                }

                let lhsIsFrequent = frequentCurrencies.contains(where: { $0.id == lhs.id })
                let rhsIsFrequent = frequentCurrencies.contains(where: { $0.id == rhs.id })
                guard lhsIsFrequent == rhsIsFrequent else {
                    return lhsIsFrequent && !rhsIsFrequent
                }

                return lhs.id < rhs.id
            }
    }
}

// MARK: - Helpers

private extension SearchCurrenciesUseCase {

    func isExactMatch(of currency: CurrencyDisplayModel, to query: String) -> Bool {
        currency.id.isExactMatchCaseInsensitive(to: query) ||
        currency.name.isExactMatchCaseInsensitive(to: query) ||
        currency.countries.contains { $0.isExactMatchCaseInsensitive(to: query) }
    }

    func prefixMatchLength(of currency: CurrencyDisplayModel, with query: String) -> Int {
        max(
            currency.id.prefixMatchLength(with: query),
            currency.name.prefixMatchLength(with: query),
            currency.countries.map { $0.prefixMatchLength(with: query) }.max() ?? 0
        )
    }
}

// MARK: - Constants

private extension SearchCurrenciesUseCase {

    enum Constants {
        static let commonCodes: Set<String> = ["BTC", "ETH", "USD"]
    }
}
