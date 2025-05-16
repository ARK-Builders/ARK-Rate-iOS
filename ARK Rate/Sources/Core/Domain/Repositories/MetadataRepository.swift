import Foundation

protocol MetadataRepository {

    func recordHasLaunchedBefore()
    func hasLaunchedBefore() -> Bool
    func recordCurrenciesFetchDate()
    func lastCurrenciesFetchDate() -> Date?
}
