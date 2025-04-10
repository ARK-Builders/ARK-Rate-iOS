import ComposableArchitecture

extension DependencyValues {

    var fetchCurrenciesUseCase: FetchCurrenciesUseCase {
        get { self[FetchCurrenciesUseCaseKey.self] }
        set { self[FetchCurrenciesUseCaseKey.self] = newValue }
    }

    var currencyCalculationUseCase: CurrencyCalculationUseCase {
        get { self[CurrencyCalculationUseCaseKey.self] }
        set { self[CurrencyCalculationUseCaseKey.self] = newValue }
    }

    var currencyRepository: CurrencyRepository {
        get { self[CurrencyRepositoryKey.self] }
        set { self[CurrencyRepositoryKey.self] = newValue }
    }

    var quickCalculationRepository: QuickCalculationRepository {
        get { self[QuickCalculationRepositoryKey.self] }
        set { self[QuickCalculationRepositoryKey.self] = newValue }
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

    var quickCalculationLocalDataSource: QuickCalculationLocalDataSource {
        get { self[QuickCalculationLocalDataSourceKey.self] }
        set { self[QuickCalculationLocalDataSourceKey.self] = newValue }
    }
}

// MARK: - FetchCurrenciesUseCase

private enum FetchCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: FetchCurrenciesUseCase = FetchCurrenciesUseCase(currencyRepository: DependencyValues._current.currencyRepository)
}

// MARK: - CurrencyCalculationUseCase

private enum CurrencyCalculationUseCaseKey: DependencyKey {

    static let liveValue: CurrencyCalculationUseCase = CurrencyCalculationUseCaseImpl()
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

// MARK: - QuickCalculationRepository

private enum QuickCalculationRepositoryKey: DependencyKey {

    static let liveValue: QuickCalculationRepository = QuickCalculationRepositoryImpl(
        localDataSource: DependencyValues._current.quickCalculationLocalDataSource
    )
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

// MARK: - QuickCalculationLocalDataSource

private enum QuickCalculationLocalDataSourceKey: DependencyKey {

    static let liveValue: QuickCalculationLocalDataSource = QuickCalculationSwiftDataDataSource()
}
