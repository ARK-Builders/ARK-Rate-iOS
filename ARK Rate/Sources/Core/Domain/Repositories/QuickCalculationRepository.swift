protocol QuickCalculationRepository {

    func get() throws -> [QuickCalculation]
    func getWherePinned() throws -> [QuickCalculation]
    func save(_ calculation: QuickCalculation) throws
}
