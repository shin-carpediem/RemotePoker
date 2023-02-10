import Foundation

actor SelectThemeColorViewModel: SelectThemeColorObservable {
    // MARK: - SelectThemeColorObservable

    @MainActor
    @Published var isButtonEnabled = true

    @MainActor
    @Published var isShownLoader = false

    @MainActor
    @Published var isShownBanner = false

    @MainActor
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    @MainActor
    @Published var themeColorList = [CardPackage.ThemeColor]()

    @MainActor
    @Published var selectedThemeColor: CardPackage.ThemeColor?
}
