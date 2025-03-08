//
//  ARKRateApp.swift
//  ARK Rate
//
//  Created by Huỳnh Kỳ Phú on 3/3/25.
//

import SwiftUI
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

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            CurrenciesView(store: store)
        }
    }
}
