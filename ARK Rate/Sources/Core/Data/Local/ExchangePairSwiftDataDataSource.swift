import SwiftData

struct ExchangePairSwiftDataDataSource: ExchangePairLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [ExchangePairDTO] {
        let models = try SwiftDataManager.shared.get(ExchangePairModel.self)
        return models.map { $0.toExchangePairDTO }
    }

    func save(_ pair: ExchangePairDTO) throws {
        let model = pair.toExchangePairModel
        try SwiftDataManager.shared.insertOrUpdate(model)
    }
}
