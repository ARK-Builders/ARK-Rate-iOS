import SwiftData

final class SwiftDataManager {

    // MARK: - Properties

    static let shared = SwiftDataManager()

    var modelContext: ModelContext?

    // MARK: - Methods

    func insert(_ models: [CurrencyModel]) throws {
        guard let modelContext else { return }
        models.forEach { modelContext.insert($0) }
        try modelContext.save()
    }

    func get() throws -> [CurrencyModel] {
        guard let modelContext else { return [] }
        let fetchDescriptor = FetchDescriptor<CurrencyModel>()
        return try modelContext.fetch(fetchDescriptor)
    }
}
