protocol QuickCalculationRepository {

    func save(_ pair: QuickCalculation) throws
    func get() throws -> [QuickCalculation]
}
