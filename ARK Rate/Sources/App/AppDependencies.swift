import ComposableArchitecture

extension DependencyValues {

    var loadCurrenciesUseCase: LoadCurrenciesUseCase {
        get { self[LoadCurrenciesUseCaseKey.self] }
        set { self[LoadCurrenciesUseCaseKey.self] = newValue }
    }

    var loadFrequentCurrenciesUseCase: LoadFrequentCurrenciesUseCase {
        get { self[LoadFrequentCurrenciesUseCaseKey.self] }
        set { self[LoadFrequentCurrenciesUseCaseKey.self] = newValue }
    }

    var loadQuickCalculationsUseCase: LoadQuickCalculationsUseCase {
        get { self[LoadQuickCalculationsUseCaseKey.self] }
        set { self[LoadQuickCalculationsUseCaseKey.self] = newValue }
    }

    var currencyCalculationUseCase: CurrencyCalculationUseCase {
        get { self[CurrencyCalculationUseCaseKey.self] }
        set { self[CurrencyCalculationUseCaseKey.self] = newValue }
    }

    var currencyRepository: CurrencyRepository {
        get { self[CurrencyRepositoryKey.self] }
        set { self[CurrencyRepositoryKey.self] = newValue }
    }

    var currencyStatisticRepository: CurrencyStatisticRepository {
        get { self[CurrencyStatisticRepositoryKey.self] }
        set { self[CurrencyStatisticRepositoryKey.self] = newValue }
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

    var currencyStatisticLocalDataSource: CurrencyStatisticLocalDataSource {
        get { self[CurrencyStatisticLocalDataSourceKey.self] }
        set { self[CurrencyStatisticLocalDataSourceKey.self] = newValue }
    }

    var quickCalculationLocalDataSource: QuickCalculationLocalDataSource {
        get { self[QuickCalculationLocalDataSourceKey.self] }
        set { self[QuickCalculationLocalDataSourceKey.self] = newValue }
    }
}

// MARK: - LoadCurrenciesUseCase

private enum LoadCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: LoadCurrenciesUseCase = LoadCurrenciesUseCase(
        currencyRepository: DependencyValues._current.currencyRepository
    )
}

// MARK: - LoadFrequentCurrenciesUseCase

private enum LoadFrequentCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: LoadFrequentCurrenciesUseCase = LoadFrequentCurrenciesUseCase(
        currencyRepository: DependencyValues._current.currencyRepository,
        currencyStatisticRepository: DependencyValues._current.currencyStatisticRepository
    )
}

// MARK: - LoadQuickCalculationsUseCase

private enum LoadQuickCalculationsUseCaseKey: DependencyKey {

    static let liveValue: LoadQuickCalculationsUseCase = LoadQuickCalculationsUseCase(
        quickCalculationRepository: DependencyValues._current.quickCalculationRepository,
        currencyCalculationUseCase: DependencyValues._current.currencyCalculationUseCase
    )
}

// MARK: - CurrencyCalculationUseCase

private enum CurrencyCalculationUseCaseKey: DependencyKey {

    static let liveValue: CurrencyCalculationUseCase = CurrencyCalculationUseCase(
        currencyRepository: DependencyValues._current.currencyRepository
    )
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

// MARK: - CurrencyStatisticRepository

private enum CurrencyStatisticRepositoryKey: DependencyKey {

    static let liveValue: CurrencyStatisticRepository = CurrencyStatisticRepositoryImpl(
        localDataSource: DependencyValues._current.currencyStatisticLocalDataSource
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

// MARK: - CurrencyStatisticLocalDataSource

private enum CurrencyStatisticLocalDataSourceKey: DependencyKey {

    static let liveValue: CurrencyStatisticLocalDataSource = CurrencyStatisticSwiftDataDataSource()
}

// MARK: - QuickCalculationLocalDataSource

private enum QuickCalculationLocalDataSourceKey: DependencyKey {

    static let liveValue: QuickCalculationLocalDataSource = QuickCalculationSwiftDataDataSource()
}
