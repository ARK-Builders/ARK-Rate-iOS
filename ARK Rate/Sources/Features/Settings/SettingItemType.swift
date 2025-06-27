enum SettingItemType: CaseIterable {

    case changeAppLanguage
    case about

    var title: String {
        switch self {
        case .changeAppLanguage: StringResource.changeAppLanguage.localized
        case .about: StringResource.about.localized
        }
    }
}

private extension SettingItemType {

    enum StringResource: String.LocalizationValue {
        case changeAppLanguage = "change_app_language"
        case about = "about_title"

        var localized: String {
            String(localized: rawValue)
        }
    }
}
