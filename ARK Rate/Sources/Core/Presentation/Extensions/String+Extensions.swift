extension String {

    static let empty = ""

    var isTrimmedEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
