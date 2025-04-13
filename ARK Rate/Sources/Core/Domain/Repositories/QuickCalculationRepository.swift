protocol QuickCalculationRepository {

    func get() throws -> [QuickCalculation]
    func save(_ calculation: QuickCalculation) throws
}
