import Foundation

actor SettingViewModel: ObservableObject, ViewModel {
    // MARK: - ViewModel

    @MainActor @Published var isButtonEnabled = true

    @MainActor @Published var isShownLoader = false

    @MainActor @Published var isShownBanner = false

    @MainActor @Published var bannerMessgage = NotificationMessage(type: .onSuccess, text: "")

    // MARK: - Router

    /// テーマカラー選択画面に遷移するか
    @MainActor @Published var willPushSelectThemeColorView = false
}
