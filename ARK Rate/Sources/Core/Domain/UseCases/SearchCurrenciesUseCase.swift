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

                let lhsIsExact = lhs.id.isExactMatchCaseInsensitive(to: query) ||
                lhs.name.isExactMatchCaseInsensitive(to: query) ||
                lhs.countries.contains { $0.isExactMatchCaseInsensitive(to: query) }
                let rhsIsExact = rhs.id.isExactMatchCaseInsensitive(to: query) ||
                rhs.name.isExactMatchCaseInsensitive(to: query) ||
                rhs.countries.contains { $0.isExactMatchCaseInsensitive(to: query) }
                guard lhsIsExact == rhsIsExact else {
                    return lhsIsExact && !rhsIsExact
                }

                let lhsPrefixLength = max(
                    lhs.id.prefixMatchLength(with: query),
                    lhs.name.prefixMatchLength(with: query),
                    lhs.countries.map { $0.prefixMatchLength(with: query) }.max() ?? 0
                )
                let rhsPrefixLength = max(
                    rhs.id.prefixMatchLength(with: query),
                    rhs.name.prefixMatchLength(with: query),
                    rhs.countries.map { $0.prefixMatchLength(with: query) }.max() ?? 0
                )
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

    func rank(of currency: CurrencyDisplayModel, with query: String) -> Int {
        let codeMatchLength = query.prefixMatchLength(with: currency.id)
        let nameMatchLength = query.prefixMatchLength(with: currency.name)
        let countryMatchLength = currency.countries.map { query.prefixMatchLength(with: $0) }.max() ?? 0
        let maxMatchLength = max(codeMatchLength, nameMatchLength, countryMatchLength)
        return maxMatchLength
    }
}

// MARK: - Constants

private extension SearchCurrenciesUseCase {

    enum Constants {
        static let commonCodes: Set<String> = ["BTC", "ETH", "USD"]
    }
}
