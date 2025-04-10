import Foundation
import SwiftData

final class SwiftDataManager {

    // MARK: - Properties

    static let shared = SwiftDataManager()

    var modelContext: ModelContext!

    // MARK: - Methods

    func get<T: PersistentModel>(predicate: Predicate<T>? = nil, limit: Int? = nil) throws -> [T] {
        var fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        fetchDescriptor.fetchLimit = limit
        return try modelContext.fetch(fetchDescriptor)
    }

    func get<T: PersistentModel>(predicate: Predicate<T>? = nil) throws -> T? {
        try get(predicate: predicate, limit: 1).first
    }

    func insert<T: PersistentModel>(_ model: T, commit: Bool = true) throws {
        modelContext.insert(model)
        if commit { try save() }
    }

    func insert<T: PersistentModel>(_ models: [T], commit: Bool = true) throws {
        for model in models {
            try insert(model, commit: commit)
        }
    }

    func save() throws {
        try modelContext.save()
    }
}
