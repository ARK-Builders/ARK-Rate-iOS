struct FetchCurrenciesUseCase {

    // MARK: - Properties

    let fiatCurrencyRepository: FiatCurrencyRepository
    // let cryptoCurrencyRepository: CryptoCurrencyRepository

    // MARK: - Initialization

    init(fiatCurrencyRepository: FiatCurrencyRepository) {
        self.fiatCurrencyRepository = fiatCurrencyRepository
    }

    // MARK: - Methods

    func fetchFiatCurrencies() async throws -> [FiatCurrency] {
        try await fiatCurrencyRepository.get()
    }
}
