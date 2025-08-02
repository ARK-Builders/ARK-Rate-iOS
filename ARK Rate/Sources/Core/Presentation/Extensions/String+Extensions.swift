extension String {

    static let empty = ""

    var isTrimmedEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func isExactMatchCaseInsensitive(to aString: String) -> Bool {
        lowercased() == aString.lowercased()
    }

    func hasPrefixCaseInsensitive(with aString: String) -> Bool {
        lowercased().hasPrefix(aString.lowercased())
    }

    func prefixMatchLength(with aString: String, options: String.CompareOptions = [.caseInsensitive]) -> Int {
        commonPrefix(with: aString, options: options).count
    }
}
