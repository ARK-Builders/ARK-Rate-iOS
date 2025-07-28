import SwiftUI

struct HoverDropDelegate: DropDelegate {

    // MARK: - Properties

    private let onHovering: ButtonAction
    private let onDropCompleted: ButtonAction

    // MARK: - Initialization

    init(
        onHovering: @escaping ButtonAction,
        onDropCompleted: @escaping ButtonAction
    ) {
        self.onHovering = onHovering
        self.onDropCompleted = onDropCompleted
    }

    // MARK: - Conformance

    func dropEntered(info: DropInfo) {
        onHovering()
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        onDropCompleted()
        return true
    }
}
