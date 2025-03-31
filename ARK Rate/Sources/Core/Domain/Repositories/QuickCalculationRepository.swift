protocol QuickCalculationRepository {

    func save(_ calculation: QuickCalculation) throws
    func get() throws -> [QuickCalculation]
}
