import Foundation

struct QuickCalculationGroupSwiftDataDataSource: QuickCalculationGroupLocalDataSource {

    // MARK: - Conformance

    func get() throws -> [QuickCalculationGroupDTO] {
        let models: [QuickCalculationGroupModel] = try SwiftDataManager.shared.get()
        return models.map(\.toQuickCalculationGroupDTO)
    }

    func get(where id: UUID) throws -> QuickCalculationGroupDTO? {
        let model: QuickCalculationGroupModel? = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id })
        return model.map(\.toQuickCalculationGroupDTO)
    }

    func get(where name: String) throws -> QuickCalculationGroupDTO? {
        let model: QuickCalculationGroupModel? = try SwiftDataManager.shared.get(predicate: #Predicate { $0.name == name })
        return model.map(\.toQuickCalculationGroupDTO)
    }

    func save(_ group: QuickCalculationGroupDTO) throws {
        try save(group, commit: true)
    }

    func save(_ groups: [QuickCalculationGroupDTO]) throws {
        for group in groups {
            try save(group, commit: false)
        }
        try SwiftDataManager.shared.save()
    }

    func delete(where id: UUID) throws {
        guard let model: QuickCalculationGroupModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) else { return }
        try SwiftDataManager.shared.delete(model)
    }
}

// MARK: - Helpers

private extension QuickCalculationGroupSwiftDataDataSource {

    func save(_ group: QuickCalculationGroupDTO, commit: Bool = false) throws {
        let id = group.id
        let name = group.name
        let model = group.toQuickCalculationGroupModel
        if let fetchedModel: QuickCalculationGroupModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.id == id }) {
            fetchedModel.name = model.name
            fetchedModel.displayOrder = model.displayOrder
            if commit {
                try SwiftDataManager.shared.save()
            }
        } else if let fetchedModel: QuickCalculationGroupModel = try SwiftDataManager.shared.get(predicate: #Predicate { $0.name == name }) {
            fetchedModel.displayOrder = model.displayOrder
            if commit {
                try SwiftDataManager.shared.save()
            }
        } else {
            try SwiftDataManager.shared.insert(model, commit: commit)
        }
    }
}
