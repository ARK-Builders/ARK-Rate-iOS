import SwiftUI

struct OutsideDropDelegate: DropDelegate {

    // MARK: - Properties

    private let onDropCompleted: ButtonAction

    // MARK: - Initialization

    init(_ onDropCompleted: @escaping ButtonAction) {
        self.onDropCompleted = onDropCompleted
    }

    // MARK: - Conformance

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        onDropCompleted()
        return true
    }
}
