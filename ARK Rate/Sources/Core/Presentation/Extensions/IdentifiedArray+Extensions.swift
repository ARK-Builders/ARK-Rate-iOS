import IdentifiedCollections

extension IdentifiedArray {

    // MARK: - Methods

    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
