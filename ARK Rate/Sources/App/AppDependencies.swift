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

    var saveQuickCalculationUseCase: SaveQuickCalculationUseCase {
        get { self[SaveQuickCalculationUseCaseKey.self] }
        set { self[SaveQuickCalculationUseCaseKey.self] = newValue }
    }

    var loadQuickCalculationGroupsUseCase: LoadQuickCalculationGroupsUseCase {
        get { self[LoadQuickCalculationGroupsUseCaseKey.self] }
        set { self[LoadQuickCalculationGroupsUseCaseKey.self] = newValue }
    }

    var currencyCalculationUseCase: CurrencyCalculationUseCase {
        get { self[CurrencyCalculationUseCaseKey.self] }
        set { self[CurrencyCalculationUseCaseKey.self] = newValue }
    }

    var togglePinnedCalculationUseCase: TogglePinnedCalculationUseCase {
        get { self[TogglePinnedCalculationUseCaseKey.self] }
        set { self[TogglePinnedCalculationUseCaseKey.self] = newValue }
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

    var quickCalculationGroupRepository: QuickCalculationGroupRepository {
        get { self[QuickCalculationGroupRepositoryKey.self] }
        set { self[QuickCalculationGroupRepositoryKey.self] = newValue }
    }

    var metadataRepository: MetadataRepository {
        get { self[MetadataRepositoryKey.self] }
        set { self[MetadataRepositoryKey.self] = newValue }
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

    var quickCalculationGroupLocalDataSource: QuickCalculationGroupLocalDataSource {
        get { self[QuickCalculationGroupLocalDataSourceKey.self] }
        set { self[QuickCalculationGroupLocalDataSourceKey.self] = newValue }
    }
}

// MARK: - LoadCurrenciesUseCase

private enum LoadCurrenciesUseCaseKey: DependencyKey {

    static let liveValue: LoadCurrenciesUseCase = LoadCurrenciesUseCase(
        currencyRepository: DependencyValues._current.currencyRepository,
        metadataRepository: DependencyValues._current.metadataRepository
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
        metadataRepository: DependencyValues._current.metadataRepository,
        quickCalculationRepository: DependencyValues._current.quickCalculationRepository,
        currencyCalculationUseCase: DependencyValues._current.currencyCalculationUseCase
    )
}

// MARK: - SaveQuickCalculationUseCase

private enum SaveQuickCalculationUseCaseKey: DependencyKey {

    static let liveValue: SaveQuickCalculationUseCase = SaveQuickCalculationUseCase(
        quickCalculationRepository: DependencyValues._current.quickCalculationRepository,
        quickCalculationGroupRepository: DependencyValues._current.quickCalculationGroupRepository,
        currencyStatisticRepository: DependencyValues._current.currencyStatisticRepository
    )
}

// MARK: - LoadQuickCalculationGroupsUseCase

private enum LoadQuickCalculationGroupsUseCaseKey: DependencyKey {

    static let liveValue: LoadQuickCalculationGroupsUseCase = LoadQuickCalculationGroupsUseCase(
        quickCalculationGroupRepository: DependencyValues._current.quickCalculationGroupRepository
    )
}

// MARK: - CurrencyCalculationUseCase

private enum CurrencyCalculationUseCaseKey: DependencyKey {

    static let liveValue: CurrencyCalculationUseCase = CurrencyCalculationUseCase(
        currencyRepository: DependencyValues._current.currencyRepository
    )
}

// MARK: - TogglePinnedCalculationUseCase

private enum TogglePinnedCalculationUseCaseKey: DependencyKey {

    static let liveValue: TogglePinnedCalculationUseCase = TogglePinnedCalculationUseCase(
        quickCalculationRepository: DependencyValues._current.quickCalculationRepository
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

// MARK: - QuickCalculationGroupRepositoryKey

private enum QuickCalculationGroupRepositoryKey: DependencyKey {

    static let liveValue: QuickCalculationGroupRepository = QuickCalculationGroupRepositoryImpl(
        localDataSource: DependencyValues._current.quickCalculationGroupLocalDataSource
    )
}

// MARK: - CurrencyStatisticRepository

private enum CurrencyStatisticRepositoryKey: DependencyKey {

    static let liveValue: CurrencyStatisticRepository = CurrencyStatisticRepositoryImpl(
        localDataSource: DependencyValues._current.currencyStatisticLocalDataSource
    )
}

// MARK: - MetadataRepository

private enum MetadataRepositoryKey: DependencyKey {

    static let liveValue: MetadataRepository = MetadataRepositoryImpl(userDefaults: .standard)
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

// MARK: - QuickCalculationGroupLocalDataSourceKey

private enum QuickCalculationGroupLocalDataSourceKey: DependencyKey {

    static let liveValue: QuickCalculationGroupLocalDataSource = QuickCalculationGroupSwiftDataDataSource()
}
