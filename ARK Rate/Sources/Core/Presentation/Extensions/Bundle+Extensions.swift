import Foundation

extension Bundle {

    static let countryDataset: [String: String] = Bundle.main.loadStringsFile(named: "CountryDataset")

    func getValue(from key: String) -> String? {
        (Bundle.main.object(forInfoDictionaryKey: key) as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }

    func loadStringsFile(named name: String) -> [String: String] {
        guard let url = url(forResource: name, withExtension: "strings"),
              let dictionary = NSDictionary(contentsOf: url) as? [String: String] else {
            return [:]
        }
        return dictionary
    }
}
