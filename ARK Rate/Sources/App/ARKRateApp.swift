import SwiftUI
import SwiftData
import ComposableArchitecture

@main
struct ARKRateApp: App {

    // MARK: - Properties

    let store = Store(
        initialState: CurrenciesFeature.State(),
        reducer: {
            CurrenciesFeature()
        }
    )

    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CurrencyModel.self,
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
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            CurrenciesView(store: store)
        }
    }
}
