import Foundation

actor SelectThemeColorViewModel: SelectThemeColorObservable {
    // MARK: - SelectThemeColorObservable

    @MainActor
    @Published var themeColorList = [CardPackageThemeColor]()

    @MainActor
    @Published var selectedThemeColor: CardPackageThemeColor?

    // MARK: - ViewModel

    @MainActor
    @Published var isButtonEnabled = true

    @MainActor
    @Published var isShownLoader = false

    @MainActor
    @Published var isShownBanner = false

    @MainActor
    @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")
}
