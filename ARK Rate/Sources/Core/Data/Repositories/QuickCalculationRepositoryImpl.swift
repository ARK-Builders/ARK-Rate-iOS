final class QuickCalculationRepositoryImpl: QuickCalculationRepository {

    // MARK: - Properties

    private let localDataSource: QuickCalculationLocalDataSource

    // MARK: - Initialization

    init(localDataSource: QuickCalculationLocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Conformance

    func save(_ calculation: QuickCalculation) throws {
        try localDataSource.save(calculation.toQuickCalculationDTO)
    }

    func get() throws -> [QuickCalculation] {
        try localDataSource.get()
            .map(\.toQuickCalculation)
            .sorted(by: { $0.calculatedDate > $1.calculatedDate })
    }
}
