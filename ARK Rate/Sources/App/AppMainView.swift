import SwiftUI
import ComposableArchitecture

struct AppMainView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<AppFeature>

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $store.selectedTabIndex.sending(\.tabIndexChanged)) {
                ForEach(TabbarItem.allCases, id: \.self) { tabbarItem in
                    tabbarContentView(tabbarItem)
                        .toolbar(.hidden, for: .tabBar)
                        .tag(tabbarItem.rawValue)
                }
            }
            CustomTabbarView(store: store)
        }
    }

    @ViewBuilder
    fileprivate func tabbarContentView(_ tabbarItem: TabbarItem) -> some View {
        switch tabbarItem {
        case .quick: QuickView(store: store.scope(state: \.quickState, action: \.quickAction))
        case .settings: SettingsView(store: store.scope(state: \.settingsState, action: \.settingsAction))
        }
    }
}

// MARK: -

private struct CustomTabbarView: View {

    // MARK: - Properties

    @Bindable var store: StoreOf<AppFeature>

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
                .background(Color.borderSecondary)
            HStack(spacing: 0) {
                ForEach(TabbarItem.allCases, id: \.self) {
                    tabbarItemView($0)
                }
            }
        }
    }

    func tabbarItemView(_ item: TabbarItem) -> some View {
        let tabIndex = item.rawValue
        let selectedTabIndex = store.selectedTabIndex
        let isSelected = tabIndex == selectedTabIndex
        let appearance = item.appearance(isSelected)
        return Button(action: { store.send(.tabIndexChanged(tabIndex)) }) {
            VStack(spacing: 4) {
                Image(uiImage: appearance.icon)
                    .padding(.top, 8)
                    .padding(.horizontal, 8)
                Text(item.title)
                    .foregroundColor(appearance.textColor)
                    .font(Font.customInterSemiBold(size: 12))
                    .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - TabbarItem

private enum TabbarItem: Int, CaseIterable {
    case quick
    case settings

    var title: String {
        switch self {
        case .quick: String(localized: "quick_title")
        case .settings: String(localized: "settings_title")
        }
    }

    func appearance(_ isSelected: Bool) -> Appearance {
        let icon: UIImage
        let textColor = isSelected ? Color.tabActive : Color.tabInactive
        switch self {
        case .quick: icon = UIImage(resource: isSelected ? ImageResource.icNavQuickEnabled : ImageResource.icNavQuickDisabled)
        case .settings: icon = UIImage(resource: isSelected ? ImageResource.icNavSettingsEnabled : ImageResource.icNavSettingsDisabled)
        }
        return Appearance(icon: icon, textColor: textColor)
    }

    typealias Appearance = (icon: UIImage, textColor: Color)
}
