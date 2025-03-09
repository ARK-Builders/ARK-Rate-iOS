import ComposableArchitecture

extension DependencyValues {

    var fetchCurrenciesUseCase: FetchCurrenciesUseCase {
        get { self[FetchCurrenciesUseCaseKey.self] }
        set { self[FetchCurrenciesUseCaseKey.self] = newValue }
    }

    var fiatCurrenciesRateAPI: FiatCurrenciesRateAPI {
        get { self[FiatCurrenciesRateAPIKey.self] }
        set { self[FiatCurrenciesRateAPIKey.self] = newValue }
    }
}

// MARK: - FetchCurrenciesUseCase

private enum FetchCurrenciesUseCaseKey: DependencyKey {

    static let liveValue = FetchCurrenciesUseCase(
        currencyRepository: CurrencyRepositoryImpl(
            fiatCurrencyDataSource: FiatCurrencyDataSource(apiClient: DependencyValues._current.fiatCurrenciesRateAPI)
        )
    )
}

// MARK: - FiatCurrenciesRateAPI

private enum FiatCurrenciesRateAPIKey: DependencyKey {

    static let liveValue: FiatCurrenciesRateAPI = FiatCurrenciesRateAPIClient()
}
