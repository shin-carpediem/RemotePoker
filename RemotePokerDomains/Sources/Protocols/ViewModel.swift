import ViewModel

public protocol ViewModel {
    /// ボタンが有効か
    @MainActor var isButtonEnabled: Bool { get set }

    /// ローダーを表示するか
    @MainActor var isShownLoader: Bool { get set }

    /// 通知バナーを表示するか
    @MainActor var isShownBanner: Bool { get set }

    /// 通知バナーのメッセージ
    @MainActor var bannerMessgage: NotificationBannerViewModel { get set }
}
