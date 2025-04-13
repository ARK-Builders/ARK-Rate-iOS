final class QuickCalculationRepositoryImpl: QuickCalculationRepository {

    // MARK: - Properties

    private let localDataSource: QuickCalculationLocalDataSource

    // MARK: - Initialization

    init(localDataSource: QuickCalculationLocalDataSource) {
        self.localDataSource = localDataSource
    }

    // MARK: - Conformance

    func get() throws -> [QuickCalculation] {
        try localDataSource.get().map(\.toQuickCalculation)
    }

    func getWherePinned() throws -> [QuickCalculation] {
        try localDataSource.getWherePinned().map(\.toQuickCalculation)
    }

    func save(_ calculation: QuickCalculation) throws {
        try localDataSource.save(calculation.toQuickCalculationDTO)
    }
}
