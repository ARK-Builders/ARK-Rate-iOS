final class ExchangePairRepositoryImpl: ExchangePairRepository {

    // MARK: - Properties

    private let localDataSource: ExchangePairLocalDataSource

    // MARK: - Initialization

    init(localDataSource: ExchangePairLocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Conformance

    func save(_ pair: ExchangePair) throws {
        try localDataSource.save(pair.toExchangePairDTO)
    }

    func get() throws -> [ExchangePair] {
        try localDataSource.get()
            .map { $0.toExchangePair }
    }
}
