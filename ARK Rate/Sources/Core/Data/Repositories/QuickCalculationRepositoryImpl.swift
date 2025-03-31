final class QuickCalculationRepositoryImpl: QuickCalculationRepository {

    // MARK: - Properties

    private let localDataSource: QuickCalculationLocalDataSource

    // MARK: - Initialization

    init(localDataSource: QuickCalculationLocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Conformance

    func save(_ pair: QuickCalculation) throws {
        try localDataSource.save(pair.toQuickCalculationDTO)
    }

    func get() throws -> [QuickCalculation] {
        try localDataSource.get()
            .map { $0.toQuickCalculation }
    }
}
