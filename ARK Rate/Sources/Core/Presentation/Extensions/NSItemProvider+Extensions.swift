import UniformTypeIdentifiers

extension NSItemProvider {

    func loadDataRepresentation(_ identifier: String) async -> Int? {
        guard let stringValue: String = await loadDataRepresentation(identifier),
              let intValue = Int(stringValue) else { return nil }
        return intValue
    }

    func loadDataRepresentation(_ identifier: String) async -> String? {
        await withCheckedContinuation { continuation in
            loadDataRepresentation(forTypeIdentifier: identifier) { data, _ in
                if let data, let text = String(data: data, encoding: .utf8) {
                    continuation.resume(returning: text)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
