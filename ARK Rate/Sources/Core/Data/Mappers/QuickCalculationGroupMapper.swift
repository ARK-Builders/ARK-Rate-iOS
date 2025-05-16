// MARK: -

extension QuickCalculationGroup {

    var toQuickCalculationGroupDTO: QuickCalculationGroupDTO {
        QuickCalculationGroupDTO(
            id: id,
            name: name,
            addedDate: addedDate,
            displayOrder: displayOrder
        )
    }
}

// MARK: -

extension QuickCalculationGroupDTO {

    var toQuickCalculationGroup: QuickCalculationGroup {
        QuickCalculationGroup(
            id: id,
            name: name,
            addedDate: addedDate,
            displayOrder: displayOrder
        )
    }

    var toQuickCalculationGroupModel: QuickCalculationGroupModel {
        QuickCalculationGroupModel(
            id: id,
            name: name,
            addedDate: addedDate,
            displayOrder: displayOrder
        )
    }
}

// MARK: -

extension QuickCalculationGroupModel {

    var toQuickCalculationGroupDTO: QuickCalculationGroupDTO {
        QuickCalculationGroupDTO(
            id: id,
            name: name,
            addedDate: addedDate,
            displayOrder: displayOrder
        )
    }
}
