import Foundation

actor SelectThemeColorViewModel: SelectThemeColorObservable {
    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - SelectThemeColorObservable

    @MainActor @Published var themeColorList: [ThemeColor] = []

    @MainActor @Published var selectedThemeColor: ThemeColor?
}
