import ViewModel

public protocol ViewModel {
    /// ボタンが有効か
    var isButtonsEnabled: Bool { get set }

    /// ローダーを表示するか
    var isLoaderShown: Bool { get set }

    /// 通知バナーを表示するか
    var isBannerShown: Bool { get set }

    /// 通知バナーのメッセージ
    var bannerMessgage: NotificationBannerViewModel { get set }
}
