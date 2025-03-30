import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct ARKRateApp: App {

    // MARK: - Properties

    let store = Store(
        initialState: AppFeature.State(),
        reducer: { AppFeature() }
    )

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CurrencyModel.self,
            ExchangePairModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // MARK: - Initialization

    init() {
        SwiftDataManager.shared.modelContext = sharedModelContainer.mainContext
        store.send(.currenciesAction(.fetchCurrencies))
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            AppMainView(store: store)
        }
    }
}
