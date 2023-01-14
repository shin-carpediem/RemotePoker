import Foundation

actor SettingViewModel: SettingObservable {
    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - SettingObservable

    /// テーマカラー選択画面に遷移するか
    @MainActor @Published var willPushSelectThemeColorView = false
}
