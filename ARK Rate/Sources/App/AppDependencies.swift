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

    var currencyLocalDataSource: CurrencyLocalDataSource {
        get { self[CurrencyLocalDataSourceKey.self] }
        set { self[CurrencyLocalDataSourceKey.self] = newValue }
    }
}

// MARK: - FetchCurrenciesUseCase

private enum FetchCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: FetchCurrenciesUseCase = {
        let localDataSource = DependencyValues._current.currencyLocalDataSource
        let fiatCurrencyDataSource = FiatCurrencyDataSource(apiClient: DependencyValues._current.fiatCurrenciesRateAPI)
        let currencyRepository = CurrencyRepositoryImpl(localDataSource: localDataSource, fiatCurrencyDataSource: fiatCurrencyDataSource)
        return FetchCurrenciesUseCase(currencyRepository: currencyRepository)
    }()
}

// MARK: - FiatCurrenciesRateAPI

private enum FiatCurrenciesRateAPIKey: DependencyKey {

    static let liveValue: FiatCurrenciesRateAPI = FiatCurrenciesRateAPIClient()
}

// MARK: - CurrencyLocalDataSource

private enum CurrencyLocalDataSourceKey: DependencyKey {

    static var liveValue: CurrencyLocalDataSource {
        return CurrencySwiftDataDataSource()
    }
}
