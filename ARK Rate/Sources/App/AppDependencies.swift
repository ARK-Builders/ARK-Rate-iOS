import ComposableArchitecture

extension DependencyValues {

    var fetchCurrenciesUseCase: FetchCurrenciesUseCase {
        get { self[FetchCurrenciesUseCaseKey.self] }
        set { self[FetchCurrenciesUseCaseKey.self] = newValue }
    }

    var currencyExchangeUseCase: CurrencyExchangeUseCase {
        get { self[CurrencyExchangeUseCaseKey.self] }
        set { self[CurrencyExchangeUseCaseKey.self] = newValue }
    }

    var currencyRepository: CurrencyRepository {
        get { self[CurrencyRepositoryKey.self] }
        set { self[CurrencyRepositoryKey.self] = newValue }
    }

    var fiatCurrenciesRateAPI: FiatCurrenciesRateAPI {
        get { self[FiatCurrenciesRateAPIKey.self] }
        set { self[FiatCurrenciesRateAPIKey.self] = newValue }
    }

    var cryptoCurrenciesRateAPI: CryptoCurrenciesRateAPI {
        get { self[CryptoCurrenciesRateAPIKey.self] }
        set { self[CryptoCurrenciesRateAPIKey.self] = newValue }
    }

    var currencyLocalDataSource: CurrencyLocalDataSource {
        get { self[CurrencyLocalDataSourceKey.self] }
        set { self[CurrencyLocalDataSourceKey.self] = newValue }
    }
}

// MARK: - FetchCurrenciesUseCase

private enum FetchCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: FetchCurrenciesUseCase = FetchCurrenciesUseCase(currencyRepository: DependencyValues._current.currencyRepository)
}

// MARK: - CurrencyExchangeUseCase

private enum CurrencyExchangeUseCaseKey: DependencyKey {

    static let liveValue: CurrencyExchangeUseCase = CurrencyExchangeUseCaseImpl()
}

// MARK: - CurrencyRepository

private enum CurrencyRepositoryKey: DependencyKey {

    static let liveValue: CurrencyRepository = {
        let localDataSource = DependencyValues._current.currencyLocalDataSource
        let fiatCurrencyDataSource = FiatCurrencyDataSource(apiClient: DependencyValues._current.fiatCurrenciesRateAPI)
        let cryptoCurrencyDataSource = CryptoCurrencyDataSource(apiClient: DependencyValues._current.cryptoCurrenciesRateAPI)
        return CurrencyRepositoryImpl(
            localDataSource: localDataSource,
            fiatCurrencyDataSource: fiatCurrencyDataSource,
            cryptoCurrencyDataSource: cryptoCurrencyDataSource
        )
    }()
}

// MARK: - FiatCurrenciesRateAPI

private enum FiatCurrenciesRateAPIKey: DependencyKey {

    static let liveValue: FiatCurrenciesRateAPI = FiatCurrenciesRateAPIClient()
}

// MARK: - CryptoCurrenciesRateAPI

private enum CryptoCurrenciesRateAPIKey: DependencyKey {

    static let liveValue: CryptoCurrenciesRateAPI = CryptoCurrenciesRateAPIClient()
}

// MARK: - CurrencyLocalDataSource

private enum CurrencyLocalDataSourceKey: DependencyKey {

    static let liveValue: CurrencyLocalDataSource = CurrencySwiftDataDataSource()
}
